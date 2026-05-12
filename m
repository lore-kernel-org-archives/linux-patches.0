Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0235D36AB5B;
	Tue, 12 May 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609600; cv=none; b=EuAGpzGQ10UoVHnrcXpzDH+zkQbEqO4idku13ZZ8Qq3kkb/tHK96BgsWeJENVyISRGtclM08HpEAcL2ktMbk/Pd+3vyn+6ts+ieNFpz0RSBXTtNNkFov89YCv6gD+JdVBBH+a7B/mL4lag6l5nsxQ+rj+Xn9n/1fIWK5QfGyu/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609600; c=relaxed/simple;
	bh=gniwqgc0hIViTmgPmfh9BqNxYrXyxVL/GczQg/JvR8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8ybWvvl2KZMOXf8N8fftbMPAtEllmad9I/2FmX27PoNz2M0i+wl4WjshO0HPlKwJ3iITFtTllj7ll7sO8uAei6Sd3wXSF3AlNTsz5AlDw4gxkx6R4lEPySAUXPIciaz5L9WXmFQ+S5xBnnOW+1kKlZzaUog874+R/dfG+sRSGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJVpLZlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJVpLZlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDA4C2BCB0;
	Tue, 12 May 2026 18:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609599;
	bh=gniwqgc0hIViTmgPmfh9BqNxYrXyxVL/GczQg/JvR8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJVpLZlOlry/KjMTAWeejV8YqA4P2c/R92IbI0qCDwuSJ0Q0kXcnemhIkxEXTb1w+
	 gma/FvizpxqOJ6gO4U3iybqe7o5YvGR8/ms4mCS9Q02QVmVo+lrnV/trpj4n00V+t4
	 kq78LPl53FfXpx9FaUk7vWTxy/ZuDwgLAK/g/drM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 259/307] mptcp: pm: kernel: reset fullmesh counter after flush
Date: Tue, 12 May 2026 19:40:54 +0200
Message-ID: <20260512173945.593352954@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 1774d3cf3cf17baaf30c095606cda496268283b3 upstream.

This variable counts how many MPTCP endpoints have a 'fullmesh' flag
set. After having flushed all MPTCP endpoints, it is then needed to
reset this counter.

Without this reset, this counter exposed to the userspace is wrong, but
also non-fullmesh endpoints added after the flush will not be taken into
account to create subflows in reaction to ADD_ADDRs.

Fixes: f88191c7f361 ("mptcp: pm: in-kernel: record fullmesh endp nb")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260422-mptcp-inc-limits-v6-0-903181771530%40kernel.org?part=15
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260427-net-mptcp-misc-fixes-7-1-rc2-v1-4-7432b7f279fa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_kernel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -1278,6 +1278,7 @@ static void __reset_counters(struct pm_n
 	WRITE_ONCE(pernet->endp_signal_max, 0);
 	WRITE_ONCE(pernet->endp_subflow_max, 0);
 	WRITE_ONCE(pernet->endp_laminar_max, 0);
+	WRITE_ONCE(pernet->endp_fullmesh_max, 0);
 	pernet->endpoints = 0;
 }
 


