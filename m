Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF0276C9C;
	Tue, 20 Feb 2024 21:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463650; cv=none; b=cZfro7Ow6brLGfBXGYgfUEgB0UCvxy+cYlHShtxxhz7esjYyPI/aK3RYf7olrhCZA9ruMw9xOPkST0Rt6++5WHB7NCZgPLEWuLuprxs92BXt365vP6Nx2+6lL1ON334OHmoHu0CaQUhDrP0Gsq4TzuG2IJznrIJro0DhxD2PF3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463650; c=relaxed/simple;
	bh=ZSDMeDxA86A82W9h7/gmBBdJzDE7Nec9SEOGDeVMWYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo2XgAbzoVSzA5IBGsKnqp2NNFZ5JQr5qASflgQ4R1mWdOcMO/uLbjgTXMdwJMVvNjaWI+NLAnJRPxIUi/+qwbVeAIHrYfb0h0OwuyeAOS+bx9ghEwoaOeitY9nRiu19zzUZwswDR/M/SsG7JiMPDpzLw5r9nEylHuHf4O/SM2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TF1vmwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TF1vmwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480CCC433F1;
	Tue, 20 Feb 2024 21:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463649;
	bh=ZSDMeDxA86A82W9h7/gmBBdJzDE7Nec9SEOGDeVMWYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TF1vmwM2wtJACj+sPYZqbhFO7QPqQttKepyjSnvGGrlKfWJ9u+g0NZKKO5DwzFVA
	 jqvSP8WYlZiaRpmra70eV/PfmB6wrJ8P+1baV5PkCuOnytaGJJxxb58KUmi6P0ufMJ
	 Nv10AymQuoeQewR9djfIR+nPTh+d97mJ1c8TDeeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 109/331] selftests: mptcp: increase timeout to 30 min
Date: Tue, 20 Feb 2024 21:53:45 +0100
Message-ID: <20240220205641.034222530@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/net/mptcp/settings |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/settings
+++ b/tools/testing/selftests/net/mptcp/settings
@@ -1 +1 @@
-timeout=1200
+timeout=1800


