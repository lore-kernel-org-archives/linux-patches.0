Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66597248BA6;
	Wed, 15 Jan 2025 10:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938268; cv=none; b=mUKSf3b5hQvPNlgAaWeBXbs0A1yt6rfh2IOAmml53exqSiqWHyW1xq3u313E4riUn1JgIIaFJS4KQGFKOZ2+fxIw4iHedU4TuCtKCODHzF6an1P92vfVq9g1q9P5AqvLJQaqGeh5frCAa2LuvJhqq4TWTK/M/ccTuPFmRCmZaiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938268; c=relaxed/simple;
	bh=yWCnOfxVxQbozFShAMwEnCDIoTbYkdyWrcVHNnCVqRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTpALVepuemXcZ6EnDqh7c9hw/+0W9Ti0+zjtuIuMjNdAYXBd+DAlGv2NWdpIbQ7FjwQO9o2sKixJYRdT1G4IvUcFpGkqdXB277+Rw/fNmSCesa4P3XXZ2AeSQclm0NTPsYTT/qXB9hNM9CS4ku/+55v9VK0THZx8iydRSypse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPcSaRcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPcSaRcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B54FC4CEDF;
	Wed, 15 Jan 2025 10:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938268;
	bh=yWCnOfxVxQbozFShAMwEnCDIoTbYkdyWrcVHNnCVqRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPcSaRcZeyd2183YIodPhP7pZqEkEYPbydDgIpYhjpm3WM3zoiwre0D4IURXDYMB2
	 X4880z5lJ1dDoOL9REmpmrQsf3yrB8cYlKjiyipINvqzjBxuJA4Njqvdm42nukVULJ
	 2j9Cw/cbGbY6OqQawZ6Oaw5pl1PjUvVR8B3K+1L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 092/189] mptcp: sysctl: avail sched: remove write access
Date: Wed, 15 Jan 2025 11:36:28 +0100
Message-ID: <20250115103609.997650553@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 771ec78dc8b48d562e6015bb535ed3cd37043d78 upstream.

'net.mptcp.available_schedulers' sysctl knob is there to list available
schedulers, not to modify this list.

There are then no reasons to give write access to it.

Nothing would have been written anyway, but no errors would have been
returned, which is unexpected.

Fixes: 73c900aa3660 ("mptcp: add net.mptcp.available_schedulers")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-1-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 38d8121331d4..d9b57fab2a13 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -228,7 +228,7 @@ static struct ctl_table mptcp_sysctl_table[] = {
 	{
 		.procname = "available_schedulers",
 		.maxlen	= MPTCP_SCHED_BUF_MAX,
-		.mode = 0644,
+		.mode = 0444,
 		.proc_handler = proc_available_schedulers,
 	},
 	{
-- 
2.48.0



