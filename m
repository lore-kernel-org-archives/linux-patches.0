Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1781DFE10;
	Wed,  6 Nov 2024 13:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898805; cv=none; b=IqFQyLqkGbalpOyd3VAlSem7az3jgo7QVDa8WDCFHk/DU2ReMpJ+chDoxsMzjnm8ZXTxsqo07QKyO3ceGGDYMiuj1kh3rnEhR/Di+lpNOIrIUqUjwlqkgEqK+xfNRpthe7In3W7IKmGW3so103hI5koWsHwOLLI5ue6F+cBtWro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898805; c=relaxed/simple;
	bh=2sjpqsHgovd0H6ONBNbID5JgOoY4EChB/7p9e2v0OHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMA2pWAL81QrIEcAtQFxbr5O8AKNTZ7uTG9cj6PzYZQpn1ya0hAUE9XHeNRzp10DnF8gKNHrJpoG+rdYW9A3ZgUsBv1Lm5rsa2HMmIAL5KQl9gvzrt/uDl/crCuuW6frF5eVY8nE4s9BLeP0FBikAZzBP2fhCTJNRDBm5QsRXRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qk7X+3jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qk7X+3jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974D6C4CED4;
	Wed,  6 Nov 2024 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898805;
	bh=2sjpqsHgovd0H6ONBNbID5JgOoY4EChB/7p9e2v0OHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qk7X+3jTKM2HYkemYJTEOX3579KaxI+asU0vp82M5voXiSzLDFsIzYYt+GW0q77wZ
	 Wy/wskUd8U0ALpfTpK9+1A4n6nIRGO54XIvYDTE8BUVI6S8EUsk1hOhRT53tUvAuZC
	 qckjjJ9kwNF8C8ovPugYOi0KTMhdIL7a7E47+E6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 362/462] s390/sclp_vt220: Convert newlines to CRLF instead of LFCR
Date: Wed,  6 Nov 2024 13:04:15 +0100
Message-ID: <20241106120340.470584275@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -325,7 +325,7 @@ sclp_vt220_add_msg(struct sclp_vt220_req
 	buffer = (void *) ((addr_t) sccb + sccb->header.length);
 
 	if (convertlf) {
-		/* Perform Linefeed conversion (0x0a -> 0x0a 0x0d)*/
+		/* Perform Linefeed conversion (0x0a -> 0x0d 0x0a)*/
 		for (from=0, to=0;
 		     (from < count) && (to < sclp_vt220_space_left(request));
 		     from++) {
@@ -334,8 +334,8 @@ sclp_vt220_add_msg(struct sclp_vt220_req
 			/* Perform conversion */
 			if (c == 0x0a) {
 				if (to + 1 < sclp_vt220_space_left(request)) {
-					((unsigned char *) buffer)[to++] = c;
 					((unsigned char *) buffer)[to++] = 0x0d;
+					((unsigned char *) buffer)[to++] = c;
 				} else
 					break;
 


