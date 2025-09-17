Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AF5337EB4;
	Wed, 17 Sep 2025 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112897; cv=none; b=IuwkmAcAlnRu3VpaCN5YoSKzPrckh1wfM4Wwf66tPewjebWSfSMpp/NWV/TUPiFDCQbi/4G/YtQogETZjHB1BsqrluO03SfhJ4NFNBgYvRVw8sZWKe3XPqr+g/yVeS5LdJu/bvY8H06mHQrrkrXuPS7Y3o52P2CUajp1BWS9k6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112897; c=relaxed/simple;
	bh=xljqGnbEnHQeGlRQlU/pEGKgZQ5V97I2XriO4kLuMi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCzNDSsD6Ej6l++28+THHaOxbxVSex199OSlf4qnQQ7H8GJEeKLhiZIuKcbkiQF/ejYFccf6E2rINi6ji4sogn6nsVXibMj0lhni9ugwSfY70RlHDZgl1PUtpZcU1z4gHgRh7njras9cQhnXsYUX3n2XTU4O8wt1MTpQNN8UFOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyRJiso6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyRJiso6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0E6C4CEF0;
	Wed, 17 Sep 2025 12:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112897;
	bh=xljqGnbEnHQeGlRQlU/pEGKgZQ5V97I2XriO4kLuMi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyRJiso6SMz8AzOXeMVW840zETd3hYPXPWpWgCpVLnLkn1HUj79GR63bddVRstPaz
	 qkVP0e66anceOi/G0DiIyEiS9TRDokqmyALoEs1ZcXbwolHH4jdDEZOkIN7qHTn5+B
	 S1F3zA93BjqUicZ6EiWUYOTcUIeUhn+2TsR6x51g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 055/189] netlink: specs: mptcp: fix if-idx attribute type
Date: Wed, 17 Sep 2025 14:32:45 +0200
Message-ID: <20250917123353.209144772@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 7094b84863e5832cb1cd9c4b9d648904775b6bd9 upstream.

This attribute is used as a signed number in the code in pm_netlink.c:

  nla_put_s32(skb, MPTCP_ATTR_IF_IDX, ssk->sk_bound_dev_if))

The specs should then reflect that. Note that other 'if-idx' attributes
from the same .yaml file use a signed number as well.

Fixes: bc8aeb2045e2 ("Documentation: netlink: add a YAML spec for mptcp")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250908-net-mptcp-misc-fixes-6-17-rc5-v1-1-5f2168a66079@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/mptcp_pm.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/netlink/specs/mptcp_pm.yaml
+++ b/Documentation/netlink/specs/mptcp_pm.yaml
@@ -256,7 +256,7 @@ attribute-sets:
         type: u32
       -
         name: if-idx
-        type: u32
+        type: s32
       -
         name: reset-reason
         type: u32


