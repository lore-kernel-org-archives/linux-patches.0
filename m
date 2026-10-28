Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217291;
	b=s4l2ISMajlNEsS2Rt8pmuwAWZV0JTAThp6TMOQEZEAcNW2ISkISnkNiW1ylyIUIL08sY
	 s4FqLy8DQ3OUIxNhqauHv65L6fSTup9W0Tf0Ao3lMjzyd8hmiKCCASwjcJL5zwNMxyiVv
	 kKYCSANn8zysjvjsTWTdXVHRlFd9IIeyZKKNO0BwWv1i2KF6W0hgrX1E9tLL3G2IB8TZs
	 NK21yBnknMdQEOXhMaiWwwlGWG2tDXraAhvjtI2s4Vh6hoBQ2M6CQyZvfjmacPRpbLHEO
	 4EBRa2VMctnEkayIx5JwB2nUMP4jJONx3HRBACXu8y+6lWwcEwaxFpAedXYicqA2KaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25TjeARqxAVdi50j/20hXY/80m89FCKmFT8iEYVQI0k=;
	b=v/ZoF/lJI6l+u+7IbGkdrebioEeAEthQVHCwFJT+B/qrd7BS9Z6J7hl5rlt0/e9VHFoa
	 0jQyqqcFz+23wIIabXE/5nBlxJ0Hi8SLN21LmFr9GG74Slb8SwjHCymI3lQyCczYUIoqW
	 4gM8lLFyrFwvKhGqtFtPFzroAGHm7hWdoc3SjL9r9j1mMKfW2uP8fRZKsJlhNrgiREbGA
	 zpzaGPP8wgDdXX+GWVYgAjOXdK4dL6o5QyEqj2kfauDb3pQ+UQXl7d0KIXE1rYLZqNJCh
	 v2TChkJoqOiz8FqLZaKXujOwLPVYDsx/36ua7G+B23GwLrRG0ikCGpr+SAk+hSd9QkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNyreymh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890D0606A31A;
	Wed, 28 Oct 2026 19:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNyreymh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FAC1F01829;
	Wed, 28 Oct 2026 19:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217291;
	bh=25TjeARqxAVdi50j/20hXY/80m89FCKmFT8iEYVQI0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNyreymhWsF6wn1IHaAFG3gkD83sYBdyDjlADngF2UjuJOtPfk/LC+74i6TO2ssuq
	 TLaBDDTfWI8YFcWiciLbAK9qPe7EQ0nfHvMJiwKkqhQW0nGJUfKYvn0i0rBrlbpAdq
	 98SG5eYXlEo28IrW3QQ1CtN5f+iVJ/ufSnzlICQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b0373017f711c06ada64@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1853/1887] fs/ntfs3: reject index allocation if $BITMAP is empty but blocks exist
Date: Wed, 28 Oct 2026 18:05:49 +0100
Message-ID: <20261028170541.617940784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 0dc7117da8f92dd5fe077d712a756eccbe377d40 ]

Index allocation requires at least one bit in the $BITMAP attribute to
track usage of index entries. If the bitmap is empty while index blocks
are already present, this reflects on-disk corruption.

syzbot triggered this condition using a malformed NTFS image. During a
rename() operation involving a long filename (which spans multiple
index entries), the empty bitmap allowed the name to be added without
valid tracking. Subsequent deletion of the original entry failed with
-ENOENT, due to unexpected index state.

Reject such cases by verifying that the bitmap is not empty when index
blocks exist.

Reported-by: syzbot+b0373017f711c06ada64@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0373017f711c06ada64
Fixes: d99208b91933 ("fs/ntfs3: cancle set bad inode after removing name fails")
Tested-by: syzbot+b0373017f711c06ada64@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 82feda419c0aa..8572453693898 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1552,6 +1552,16 @@ static int indx_add_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
 			bmp_size = bmp_size_v = le32_to_cpu(bmp->res.data_size);
 		}
 
+		/*
+		 * Index blocks exist, but $BITMAP has zero valid bits.
+		 * This implies an on-disk corruption and must be rejected.
+		 */
+		if (in->name == I30_NAME &&
+		    unlikely(bmp_size_v == 0 && indx->alloc_run.count)) {
+			err = -EINVAL;
+			goto out1;
+		}
+
 		bit = bmp_size << 3;
 	}
 
-- 
2.53.0



