Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618408;
	b=QzXEHITSROTFnKqolcZBpz5zH3MPY3/6SyrXL6kRHkR16Oq7xegtrhPWDS8dqfWqlX5a
	 hbuvYJ1Tw7nxCIAzFB1kPdQkZNYbMr/3ngqAT/W/BAQnUjK+Ux/M8l3EWbl/7lbz3/tfe
	 Q4rW5Mc2M0UPA2XlErVlmpzxXAM5Acf/+yQiTXPlY0jA35PDdcTMFuAGAq1D7QROI8kpF
	 8XDClpPpWGbK1kHKs2vMrTO20LOTonQ8c8gUDLJQPkGr3utQhaK1LfSuvJGlaKaPHIKrx
	 7tdvd556evpYGureyeAzGJYt95ME0xiUw+lFBJ1DzsQyWkYye5u+8Em+W7Bq/H8vNww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uz6DFbfuPpKtEUz6GlRqDahSG2NRT7kDn3WHUgFpSXI=;
	b=CEejY6KhzVDpYYgIqfl0Nt5Sxo9s383fRebfKDkBTz91t2fdXkr8ki/RxRTg/DGryiF6
	 62tutOvidPLu2ETCQ/apNAI8xJq1qJ13D67K8jylTAblaNHHXf/5iwqJDqQn49orhCvgP
	 DlCQ4IUW/Ga6hqyGgKW2tD8ZSmx9yOerKt+oh/ANRbg4zCY/Ly8QTnHxBnNczcgJZAJK5
	 x4+dYvKDGKpKoGnHqhe7YG2vhgf2IQmIUuL7eU7/jMmzurTMNUeZr0AqbqP9gLa7dAtD+
	 boSJ3JBhCyi7MCPJFdzL7s491n8C7QGYgpSVnZH0i+k5VcWw4A9jYuKZVdSTdi7uaeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uIry3vY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04562606A321;
	Wed, 25 Nov 2026 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uIry3vY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C071F000D1;
	Wed, 25 Nov 2026 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618407;
	bh=Uz6DFbfuPpKtEUz6GlRqDahSG2NRT7kDn3WHUgFpSXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uIry3vYMjbIUasJ8sleP/dNN3YoRCMu0JvQnSftWBv3ccUlPmcBuqdAiVPXbXgaU
	 Cpf9EoJDkFDGf45dtsm4+rfz4cKmlkOOPx4GRFtmT1tMEmIzHOZlPqaio1RoY8rN/h
	 bYKANuWgCAlgTugp6tvJAkK2/S7cHeHB84inG4WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0271/1005] isofs: handle Rock Ridge long-form dates before 1900
Date: Wed, 25 Nov 2026 15:26:49 +0100
Message-ID: <20261125143828.088701737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 0cbfc16fe49629f5c1fc3628405661c2b938ec61 ]

iso_date() stores the year relative to 1900 and rejects negative values.
Rock Ridge LONG_FORM timestamps encode calendar years from 1 to 9999,
so valid years before 1900 are returned as seconds since the Unix epoch
equal to zero instead of their recorded dates. For example, an 1899
timestamp on an image produced by xorriso is reported as 1970 by stat,
and cp -p preserves that incorrect time.

Use the calendar year for both timestamp formats and pass it directly
to mktime64(). Keep the epoch fallback for year zero, while allowing
valid long-form years before 1900. Short-form dates are unchanged.

Fixes: 5ea45f54c8d6 ("isofs: fix Y2038 and Y2156 issues in Rock Ridge TF entry")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261029004902.76944-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/util.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/isofs/util.c b/fs/isofs/util.c
index 42f479da0b282..6f9a90e58a890 100644
--- a/fs/isofs/util.c
+++ b/fs/isofs/util.c
@@ -25,7 +25,7 @@ struct timespec64 iso_date(u8 *p, int flags)
 		year = (p[0] - '0') * 1000 +
 		       (p[1] - '0') * 100 +
 		       (p[2] - '0') * 10 +
-		       (p[3] - '0') - 1900;
+		       (p[3] - '0');
 		month = ((p[4] - '0') * 10 + (p[5] - '0'));
 		day = ((p[6] - '0') * 10 + (p[7] - '0'));
 		hour = ((p[8] - '0') * 10 + (p[9] - '0'));
@@ -34,7 +34,7 @@ struct timespec64 iso_date(u8 *p, int flags)
 		ts.tv_nsec = ((p[14] - '0') * 10 + (p[15] - '0')) * 10000000;
 		tz = p[16];
 	} else {
-		year = p[0];
+		year = p[0] + 1900;
 		month = p[1];
 		day = p[2];
 		hour = p[3];
@@ -45,10 +45,10 @@ struct timespec64 iso_date(u8 *p, int flags)
 		tz = flags & ISO_DATE_HIGH_SIERRA ? 0 : p[6];
 	}
 
-	if (year < 0) {
+	if (year < 1) {
 		ts.tv_sec = 0;
 	} else {
-		ts.tv_sec = mktime64(year+1900, month, day, hour, minute, second);
+		ts.tv_sec = mktime64(year, month, day, hour, minute, second);
 
 		/* sign extend */
 		if (tz & 0x80)
-- 
2.53.0



