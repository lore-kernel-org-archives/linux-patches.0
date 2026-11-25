Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624464;
	b=F/VueqMvBdn0kcesPlHXSHNsNRTY1uVDpD03rdu5SI+UNgHZiZxhFcYPXK+3oY+KSNxq
	 pI4ZFnX0e2AoBD8O+6h+WiOk4Md8ctreTpSLvvBYLrB8YSHs6fMSvR10hCC41A3E2tTf3
	 6x+BfWNUmD7yM51z+KtCgoE2jAGtojc6cMdnSjOQuUVqlbP3HObK9VjhtCKxoFv39Cs2B
	 WQ/FGIePakOt0Wq+1FnbG831OJ06/V++9uEyw79cLWq2Jp0lZSD/ALJ7sXZ7Feo46xcEW
	 DZbHHqom7To0+DBIRIOGjNWSwe32vlHWifOQ237BbSHlGcWtyRqbfgH+FuDjmYLNoLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+mSURPD1cNSk0DPKsCto9hmnSxZ+AoLJyYh79wvm7lI=;
	b=xxNosH6tdBTvqLXFOhe9tmlg1nq12keJm2Hvop5P/56JyDSeEh9P0EA5J45xuQ8ztzvc
	 kl16GShul9TDkCXmIgTnjAlYv/M4Q6ezw0T6fTouHv0G5m2jrj8Dn3mfgR9USD9Z3N9JL
	 NR2VduU515ZzEDCTh7l31B9uapQjR5NdcBpZ86zQTHAaYJH1y1fP26slz2h/3pescDn7X
	 qqRP/R+PdSUDNRHZWX9Sj0lXMOVWJJfirv6yrV+JuiPmeLdDACUTxb0/388ckk9pLT9PF
	 17OJTG1rW5ruhmVXU801oUcAFu3cvIOunKO8Yg6nsKShGfyit/CQX31mIc9TPwfnDEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdhYw3sk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8A0606A33B;
	Wed, 25 Nov 2026 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdhYw3sk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438F31F000CF;
	Wed, 25 Nov 2026 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624463;
	bh=+mSURPD1cNSk0DPKsCto9hmnSxZ+AoLJyYh79wvm7lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdhYw3skKTMVvRRrcIgAVPU5gegPQGMrheGE+Vw9SCfNH+NJqT4zRFpDCDC4wCZuj
	 sz3R52E4gxig2zqNNricRyJEZ1c3oqFAmOaxgSY048FFonwbrl4BbsOxw7hoKZ/ecQ
	 skxCGs8zpnA6aRcUT0ye1NQBkhGoHSGols7jLOjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/816] isofs: handle Rock Ridge long-form dates before 1900
Date: Wed, 25 Nov 2026 15:29:09 +0100
Message-ID: <20261125143853.845583242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



