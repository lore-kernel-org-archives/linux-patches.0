Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3225B1DF726;
	Wed,  6 Nov 2024 12:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895609; cv=none; b=Ng8gbQGzW/FNwFe0ARUqNHnlHMIKC1n8ymeps/seetGnUvKCnbvAA+YUx1j0ZWleoqZGnIE7SkLb+gTU/dl2gazS3meKqZl35EcTGreeBlA65iwlKRKi4SzNxrdLvXciJOcgWRtIw8wnhah89SHWbzUrYj0SU9N0R3965J4TOVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895609; c=relaxed/simple;
	bh=Zf/JrKA0heXWA/SKb+zO3Jqh7e1u9P82ET/gquVOkwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sc33OsMZNT2DZCN00aSoYpm2etuzYGldvQOSGzbaqWcdR/+pA0Smth9TyizcfdIYkJi3G155iNmboQatvM5mmS/77vySUcYWyU468JIwubjiucfzgeJY5eQsbzIw9R1QBdTiA6Eh3HnVWVhvABs3kgLHR15Hum7kePZqoLjHbbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgE7ry1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgE7ry1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB84C4CECD;
	Wed,  6 Nov 2024 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895609;
	bh=Zf/JrKA0heXWA/SKb+zO3Jqh7e1u9P82ET/gquVOkwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgE7ry1EEaVxtJuhLLa1dn2i3Io1W5DtgREhafkcpdtoAE1C1GhS6BQKp6ZsLYT/+
	 oQ4vBY7ScPVglIs8JujV4o2C7XQBN8nKIHuaEKghxNvtSdIBEUItaMVNzKkqSvNo/L
	 2/v7rAS2bfDk8zFWBoOICO4Z8t0HqX/hLk88SPiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.19 275/350] s390/sclp_vt220: Convert newlines to CRLF instead of LFCR
Date: Wed,  6 Nov 2024 13:03:23 +0100
Message-ID: <20241106120327.665200120@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 


