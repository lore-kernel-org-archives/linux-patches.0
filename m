Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060359;
	b=KGDuVXXGl4UfBf8y5HXWNxAjy8KoM5TU+bxSHtn4Bz2MYtIisGRd4fnYN/ymUUfVrwfG
	 /P3x5HIg1WcYnwUxKRqmtbcVJoK3KINZxKSLzFogE0VtE6BN6NP96LzdQxduVCaOGEa/p
	 Rg5+ZtwUJM5OQzD7/q3FaZOIaTJGQr6b/DneKwBjB9LiQj+UiTpDISDwqxQyAerbZDux6
	 5XQv9a7P3BxnMq0EdK+RX2Fm36pfCeL0Wi6L4HTlXvXpwcyAEnbJAStjmzbsojEC+O0Oy
	 9OHVjtCC3U+GP1k5qBsy5Rt8uVW0EOozpIQRyY/59LpT9A5Bas7Cra+zjg8tr2yE/aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/3+iXBHIOOQKMgiacFn2zsR4Top+721nyPxK85zVJAo=;
	b=zOXfbOkY9wkeJYVzBOWvvbtvK9z2pmJUVOcDZoX2Uq9Px81rCUF4sPOcoo3ZxYbOhJyV
	 sTi0SkHHwJtXIMg1BLOpM6drj56igvuAR3kEUNIQKBfqvdrZDlqsI4km7rnidjF1f13ow
	 +Oa1XdjM+10Wc4A5ijOuJdoE+BbPBcQXUIDoVxvC2C1WFgh93f0x1VJakHNGX2K1F9iuU
	 btmjt4DRdwFUHVoD7/CjEjYp5SsHsdDVwAXqjwN85x1bv8/LJ1p30NMJeZZz7poHskbwH
	 L5CXkjYJkpVNDSeE9Xt9fQhynhNHFpBN7bLDW0eRQcCYr0Q6FwbghyJari+7RwYSlTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D/6bC7TB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A2D606A32E;
	Sat,  7 Nov 2026 14:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D/6bC7TB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45FA1F008A1;
	Sat,  7 Nov 2026 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060359;
	bh=/3+iXBHIOOQKMgiacFn2zsR4Top+721nyPxK85zVJAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/6bC7TBR5nBkqucp7zFDTT7I7l6T7OmbA36FSRnVp8e/2Aq1sHord/095WG10X6c
	 bGfaA5+7FB+5SF+RZ3NJs41u8M3Xx2WTs9SDe0IpTPWJY/ZYE58BF/z6j0ZlG341ek
	 mjBqh7sNNhMUxy/DI3EVeYJQ1Ti4L53wHlVkZSBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0004/1536] Revert "s390/uv: Dont return 0 from make_hva_secure() if the operation was not successful"
Date: Sat,  7 Nov 2026 08:33:40 -0500
Message-ID: <20261107134957.792885232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

This reverts commit cd78dd7fb054945c81d7106a094590be36f0553a.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 6cf5025c1f58e..785d396c5fdb2 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -393,11 +393,8 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
 	folio_walk_end(&fw, vma);
 	mmap_read_unlock(mm);
 
-	if (rc == -E2BIG || rc == -EBUSY) {
+	if (rc == -E2BIG || rc == -EBUSY)
 		rc = s390_wiggle_split_folio(mm, folio, rc == -E2BIG);
-		if (!rc)
-			rc = -EAGAIN;
-	}
 	folio_put(folio);
 
 	return rc;
-- 
2.53.0



