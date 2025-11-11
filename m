Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264B026B76A;
	Tue, 11 Nov 2025 01:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825398; cv=none; b=XQDtNVgcE/oBgDvTKZsk4V5d+NbeQUkIdCdN8sgOBpVTKC2eklqDPvPU6p3IGlxNT9b3dqzXN6cOirVuBcek8YzEX+EzwS5NlSV0OUFVEd5pJP1cNz4COXqGG4tILNP+2iCwDw4NnxSPsMGmsc/JQdkWE2qPS2jkmxcuGzrSUa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825398; c=relaxed/simple;
	bh=JT4jiHMQc3g2fvKeYOGQMU8OJe1uQpmWsDZ59/ZfGmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSYP0KEc6kdN8j8l30eAjWNN6iWw4Z88hzWXEnEFLjXOBhQuYlXQ4FI4f7RKvxNfSn3Q2O1jxMT2rgwx2Tji/6Tm49koT3ECDQyERXpPHRg5vNWEAH3rMFmz6bNmICSfaW61xfvxmz5wjh6mLFNSAuqnisJMurD9t2xGNBmXmWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQIPABWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQIPABWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BC0C116D0;
	Tue, 11 Nov 2025 01:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825398;
	bh=JT4jiHMQc3g2fvKeYOGQMU8OJe1uQpmWsDZ59/ZfGmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQIPABWnRxtwNbIFREZudc/gsj6/oxr4S8ILkn9eOVCnCRdQuY0qwqWX59j/j4rH3
	 L+70s4FWaHrVfPbczy3Qai4sAETWeC8L7/xDBVmNSRdS1fU3ztL6JdXlK3mkqVijo6
	 Z5GWrkRAV09P2crT2cA5nidUMEUxdrM1MlXjHIyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c8c0e7ccabd456541612@syzkaller.appspotmail.com,
	Tim Hostetler <thostet@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 758/849] gve: Implement gettimex64 with -EOPNOTSUPP
Date: Tue, 11 Nov 2025 09:45:28 +0900
Message-ID: <20251111004554.760615324@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Hostetler <thostet@google.com>

[ Upstream commit 6ab753b5d8e521616cd9bd10b09891cbeb7e0235 ]

gve implemented a ptp_clock for sole use of do_aux_work at this time.
ptp_clock_gettime() and ptp_sys_offset() assume every ptp_clock has
implemented either gettimex64 or gettime64. Stub gettimex64 and return
-EOPNOTSUPP to prevent NULL dereferencing.

Fixes: acd16380523b ("gve: Add initial PTP device support")
Reported-by: syzbot+c8c0e7ccabd456541612@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c8c0e7ccabd456541612
Signed-off-by: Tim Hostetler <thostet@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20251029184555.3852952-2-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_ptp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_ptp.c b/drivers/net/ethernet/google/gve/gve_ptp.c
index e96247c9d68d2..19ae699d4b18d 100644
--- a/drivers/net/ethernet/google/gve/gve_ptp.c
+++ b/drivers/net/ethernet/google/gve/gve_ptp.c
@@ -26,6 +26,13 @@ int gve_clock_nic_ts_read(struct gve_priv *priv)
 	return 0;
 }
 
+static int gve_ptp_gettimex64(struct ptp_clock_info *info,
+			      struct timespec64 *ts,
+			      struct ptp_system_timestamp *sts)
+{
+	return -EOPNOTSUPP;
+}
+
 static long gve_ptp_do_aux_work(struct ptp_clock_info *info)
 {
 	const struct gve_ptp *ptp = container_of(info, struct gve_ptp, info);
@@ -47,6 +54,7 @@ static long gve_ptp_do_aux_work(struct ptp_clock_info *info)
 static const struct ptp_clock_info gve_ptp_caps = {
 	.owner          = THIS_MODULE,
 	.name		= "gve clock",
+	.gettimex64	= gve_ptp_gettimex64,
 	.do_aux_work	= gve_ptp_do_aux_work,
 };
 
-- 
2.51.0



