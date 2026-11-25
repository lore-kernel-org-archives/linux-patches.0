Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620289;
	b=SE1VSPOiXlU8dwXRwrJSXDJcBq/o/Pf74awmVlg9724vWO8KYx3CJ+TJMHiRlEX3IRQg
	 c3lZ/Y79bfH5hirW0H+/xw7FDJ8RfSLoMJWYyFzMnMY1ikRpa0XKF9WeC9zPECcU7on7h
	 DEueepCEUXcT1TLEKoGDynIn6KZdNvG09S5+S9T2j/6EFkDgsDwAVcf36rSQFoL2PG9Rp
	 P5rlWMfaLE7yVRDNgd/LYV7chLMXUvLcoOiZ9fVM2G1VwCDK+PVyOLbYTDSfJizNb+jbP
	 syoZvVFtUQwqvkYQt2HRPhy8lifc5VBYBEx9TC0/9qWHDVIZGBT/dS6smeNxVoc6DTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c2AN2v+3EZOOS3oJblxHmj1/2ZYdM0zCI3HIfqWWulg=;
	b=ayW9LwO04rRo3UXBeIh2gMjjFxMUTjy5+wZWs2H+Cwj3W1RFqx2zzlxVHd65NF4w8xTt
	 7sj7vzymNckRyEET/Cpzmfgn9f+0b8gSqM5RuXP5PvXCreoogmKQTGkv5P+KSJDUc2jcF
	 uLm6kXLk6W3T0ziS5rJA4Hz8fMtfw7oZa83J8WwtJTxOhr6NYcw2Yu/zQUXbONF2O6ahQ
	 r8ihpBc4T84zos1AGam+MsEGPwQ7JQeF+pRmBiKRuAjdG7Lv2xE/O6iB0dpYEh1zQEgu3
	 bAvnR3d41kfU5rvr0a7jjVzE+caibzyCdT32y5U3ZPkO3vhtkbKyL23hZmjmYtjNjJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7NLQeE6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEF6606A31E;
	Wed, 25 Nov 2026 15:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7NLQeE6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DA31F0156D;
	Wed, 25 Nov 2026 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620289;
	bh=c2AN2v+3EZOOS3oJblxHmj1/2ZYdM0zCI3HIfqWWulg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7NLQeE6RvdkuOrMiWhUGpA43S/YfaaLzdRARHXPFuif+sBHY1F6ERWnmAo4smAm5
	 RM7QXBY14omLb5pundX3RZfJMSGiRNHndVOK48FuqA5hbUC0s+B4jxXabVmXvcRbnn
	 4vHwxiCfDeV37xaj0sW9qTqAIwCtNhekqkZ4Oya0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0868/1005] dm persistent data: dont ignore writeback errors
Date: Wed, 25 Nov 2026 15:36:46 +0100
Message-ID: <20261125143842.040933108@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit fa887f2ebee7aff97eb87b3365939616ade09774 upstream.

An error returned by ie_cache_writeback could be silently overwritten by
another successful ie_cache_writeback. This commit fixes disk_ll_commit,
so that it doesn't ignore the error and returns it immediatelly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 6b06dd5a9722 ("dm space map disk: cache a small number of index entries")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -1190,17 +1190,20 @@ static dm_block_t disk_ll_max_entries(st
 
 static int disk_ll_commit(struct ll_disk *ll)
 {
-	int r = 0;
+	int r;
 	unsigned int i;
 
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
 
-		if (iec->valid && iec->dirty)
+		if (iec->valid && iec->dirty) {
 			r = ie_cache_writeback(ll, iec);
+			if (unlikely(r))
+				return r;
+		}
 	}
 
-	return r;
+	return 0;
 }
 
 int sm_ll_new_disk(struct ll_disk *ll, struct dm_transaction_manager *tm)


