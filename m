Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEC14F9C8;
	Tue, 20 Feb 2024 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462984; cv=none; b=odaPtd7yFmCdK/qn1AvAOxXNE6k3tjy/OmhEiyxA4RHqBimKTtbaQwUD4UUe5eANMjHKFI/Udh6OHjjmEft3gF7hIQp6NUklE23gWUBFdAiHPIR/WkAl8ng2kdTL93odp0nuTCArAAk68Hy0aRA2xInPcYxabS6d4xZwuFxgQJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462984; c=relaxed/simple;
	bh=R30G304cvSxKGLcOLKRDssqmkPq5mlvvwyPZCUVHLiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9BrnBHUrchPkGXQlvNOgOtaqY3z0Vwsbu1zqvAODQrHjmO0bo+NMBSrjr6i2CdAH6z/+9XToo1Uqav+2VkC5BrcCusbeTDQ7dpwuz4pz+bYKJ7+QGZ02pGXJ6P7aR9jJ34akMy6JjG6IFvrT8AILEQ69P/99cMVd+soLV8y468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Avq56qBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Avq56qBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DEBC433C7;
	Tue, 20 Feb 2024 21:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462984;
	bh=R30G304cvSxKGLcOLKRDssqmkPq5mlvvwyPZCUVHLiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Avq56qBzTf1ADN6rM1Lo4FSrm4Dc5f+Gg63/MjgklX+eGyC/nS4sMlyTQWEpSHPlX
	 ROISyerGI/OpGHHgZ18Tm8sk/UZGXMYUEhUb+94+j59hnTKPbBT4O7EJeP87x3ZFFt
	 dI6lI4FNAQ+0IM6IZUan9j+HGp/N2zovXw7hKUcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 071/197] selftests: mptcp: increase timeout to 30 min
Date: Tue, 20 Feb 2024 21:50:30 +0100
Message-ID: <20240220204843.205024977@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 4d4dfb2019d7010efb65926d9d1c1793f9a367c6 upstream.

On very slow environments -- e.g. when QEmu is used without KVM --,
mptcp_join.sh selftest can take a bit more than 20 minutes. Bump the
default timeout by 50% as it seems normal to take that long on some
environments.

When a debug kernel config is used, this selftest will take even longer,
but that's certainly not a common test env to consider for the timeout.

The Fixes tag that has been picked here is there simply to help having
this patch backported to older stable versions. It is difficult to point
to the exact commit that made some env reaching the timeout from time to
time.

Fixes: d17b968b9876 ("selftests: mptcp: increase timeout to 20 minutes")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-5-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/settings b/tools/testing/selftests/net/mptcp/settings
index 79b65bdf05db..abc5648b59ab 100644
--- a/tools/testing/selftests/net/mptcp/settings
+++ b/tools/testing/selftests/net/mptcp/settings
@@ -1 +1 @@
-timeout=1200
+timeout=1800
-- 
2.43.2



