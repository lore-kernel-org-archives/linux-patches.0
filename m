Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051589;
	b=KenPCePRxHvVTlzBH9aYsu1IknBGaB8l6q5GpqXo+6p2fW1F9aXPLjsl832o5x0nPfIB
	 3u72tJCjksaNi/8EYX7Z270u5pf6EAt+Sjdcwr/eEXpQU2IdML0WrJbTcqiLIM9LJZfPs
	 m1o/ds9u6AqUhwK8Zj3jD80C0AJihQRfy7KJkMKeLpVMV7ohrql4Fqvtr+yqzdUWtJUvK
	 62e0tw4Nf+dc3wY3WytgOZkC1OZeTJL48KbZxATGRYMnUG55cW9CTsD+YCTOwH38Nfk7h
	 iNl1+zt2mTNuuTBl/zvJGUoX5lqgPz93+75j/nDsJEBValGMcs6tuCRdwtzQOzevtLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEtm+djkqsviurGbx8xqyQebJIK7wHk5EnNUIg65k0c=;
	b=5s7Ut9u18uXt7zLztAN+fS4C5oweYoQZMGKMUbbcawwDNV1VUJpchhIoG04hhf6Lg/Oq
	 o/1cQpbkhPjBPHylQpv1bYv2w1gWhUNPazbnJQie/6pzNQcN19zdmpLUMvPw6X8Fz8+JU
	 hi7ww+lau0nUPwYPsleN6o3Hl8J/Tzo2cGl/Bq0ZIYN0o+I9nMW8xOg8oJTzQuComr+Fa
	 JTpTdRGCA2XWMvbcHyHBeZ3mKyBqTe1AyKA5MSzEmFM7p+1vCT89tmTQI9+fu/cjOfErJ
	 wAV3yZvxXLEm463qtyJrza1NfNDIF/TsJ2s9/+Lrcv8KHUVKVUhDPMsVR9cSniLgtMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zpre2KTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E12606A31C;
	Thu, 19 Nov 2026 01:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zpre2KTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432871F000C4;
	Thu, 19 Nov 2026 01:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051588;
	bh=IEtm+djkqsviurGbx8xqyQebJIK7wHk5EnNUIg65k0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zpre2KTwdxuRvI7L+kYqBhpD1pFSjnSOe5Rupv8oObC/1cjKslT4/VSptzyrcfiAt
	 iE0ZxvqwPXtYwi9t1KfM2Qe0q9pukObJ8qfpYRO3HUxX/75IPDIKFICH3wYRIlsDmj
	 G5RAvtDEc3r/oiQ/4KBM/E6qzmrKxCyFDR538OzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0215/2214] ksmbd: reject blocking compound lock requests
Date: Wed, 18 Nov 2026 15:31:31 +0100
Message-ID: <20261118150018.780980871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 16a7f7c2ecf3c893b65f0fb78fa7a7171ae0ba9e ]

Clients set SMB2_LOCKFLAG_FAIL_IMMEDIATELY when a LOCK request contains
multiple lock elements, and servers reject requests that omit it.
Accepting such a request can leave earlier elements locked while a later
element waits asynchronously, enabling prolonged partial lock ownership
and avoidable deadlocks.

Return STATUS_INVALID_PARAMETER before processing any element when a
multi-element lock request contains a blocking lock. Unlock arrays remain
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b7f79ed7a2b00..430c1e075353f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7069,6 +7069,13 @@ int smb2_lock(struct ksmbd_work *work)
 	}
 
 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
+		if (lock_count > 1 &&
+		    !(le32_to_cpu(lock_ele[0].Flags) & SMB2_LOCKFLAG_UNLOCK) &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (smb_lock->cmd < 0) {
 			err = -EINVAL;
 			goto out;
-- 
2.53.0



