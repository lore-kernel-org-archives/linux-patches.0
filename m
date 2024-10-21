Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64B71F4FB2;
	Mon, 21 Oct 2024 10:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507325; cv=none; b=o88uCeJZ5GDRoF/yjU4pf6Yv55fpzLV3SjqEtJoBwd2Q4C7bGwJ80HJvL4XTy5npUb5AIFbaDZf8AyWPardLqq/fwlqjiey6Yg/X/B5cw0vd45LznfcKs6dzfX5F14BZHT3FlRHskRdlbnR9sc12zn0pBYk5FWBk5+BpldF/ERI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507325; c=relaxed/simple;
	bh=QHrmjqxl6pUw1rTEVf5EVTNNYlQER0Dq7VYRUlGQr60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTbpTjviFiYRMBRlY1JYJieRcX5O5ePJ3JI6IGjPDcrcRWrrYcBN2BECltxqCUmP0zbGIKdqt5jd/sBDXtBG/3h1h5uNRrSFsgQA4lRkG7hnYciYbcttH/yC+gWQ6mWg5j5mH8pbl56aa8Qtp5vBjRLQV2AV22G6CtxjSaYs58Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgjsu+f/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgjsu+f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A734C4CEC3;
	Mon, 21 Oct 2024 10:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507324;
	bh=QHrmjqxl6pUw1rTEVf5EVTNNYlQER0Dq7VYRUlGQr60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgjsu+f/phvUbwhV8i5e7GZhPOeDd6AtBa9x/fU4OTtbzSPOvp//54ugFobNhlc/k
	 yioVLSP4fAPUK95HwWXowtUOXquwFGmtcFZ3JM/qOiiDFFORkkiFQuaXcOaSv+ihB1
	 +usIJvlCKEBvZL6sb8+Dd9EDDRd9lpJoatvfNE/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 40/91] s390/sclp_vt220: Convert newlines to CRLF instead of LFCR
Date: Mon, 21 Oct 2024 12:24:54 +0200
Message-ID: <20241021102251.386768442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit dee3df68ab4b00fff6bdf9fc39541729af37307c upstream.

According to the VT220 specification the possible character combinations
sent on RETURN are only CR or CRLF [0].

	The Return key sends either a CR character (0/13) or a CR
	character (0/13) and an LF character (0/10), depending on the
	set/reset state of line feed/new line mode (LNM).

The sclp/vt220 driver however uses LFCR. This can confuse tools, for
example the kunit runner.

Link: https://vt100.net/docs/vt220-rm/chapter3.html#S3.2
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Link: https://lore.kernel.org/r/20241014-s390-kunit-v1-2-941defa765a6@linutronix.de
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/sclp_vt220.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -319,7 +319,7 @@ sclp_vt220_add_msg(struct sclp_vt220_req
 	buffer = (void *) ((addr_t) sccb + sccb->header.length);
 
 	if (convertlf) {
-		/* Perform Linefeed conversion (0x0a -> 0x0a 0x0d)*/
+		/* Perform Linefeed conversion (0x0a -> 0x0d 0x0a)*/
 		for (from=0, to=0;
 		     (from < count) && (to < sclp_vt220_space_left(request));
 		     from++) {
@@ -328,8 +328,8 @@ sclp_vt220_add_msg(struct sclp_vt220_req
 			/* Perform conversion */
 			if (c == 0x0a) {
 				if (to + 1 < sclp_vt220_space_left(request)) {
-					((unsigned char *) buffer)[to++] = c;
 					((unsigned char *) buffer)[to++] = 0x0d;
+					((unsigned char *) buffer)[to++] = c;
 				} else
 					break;
 


