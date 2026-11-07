Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062693;
	b=0MqfylmhJpEZgEkczhvwk755veUZc97Rh/xbRsPMJ8Hn1Hz3pF+Vn1kSe3CcMeS/pp+y
	 mrwX5tUrf6Sr4GuXqjmaBQI8gNlEjFJN+Uu0MaGCBqsGW8cVUBzKuYKzwLWwviCDHjB3S
	 2MXwmgBgec9H6KrsEqnViHj5YjVTxNoWdKVqC/iHcYQy6ey9Rb83+oV/Ai6grADCRIgMX
	 amELtYsOtzqsEB4aIXcxwFs/1IhtNnDxysaetwYiL4GaS4HILZ0gPBzKW7f6RytQHRVMe
	 bxmwfUC3uAMo3olsk7MzB8G4W2V7ANhpXBU9+C4XP8moOMjLms0by85L8Ckw6n19P9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5qzxQaHQUywBIFayMqnwZ8mlLxFfBt/w4FePMd0tilY=;
	b=oUtfVp62ydHsU/ma05rjMZD3n4rWnotRwpmJ0RWs/z7w3cEospBN86GT/lIwFYaMWOZ0
	 NqfOXdfQ47TOwWIIp3MxfW9ua8e7dr38V9VozXf5oj+JOlX1h5WEu9KVF56Ks0lD599s9
	 rGM8jFBplr34fkPW+bRYIR1nY8Lsk41e47Fh489QMcZZAu1RzTcAxOgDXTT5lM8GSrCEv
	 MuORqlX1wbVu/6w1WigFuGdHWrg8Fz9ai5QmftzYj8PMn+rlB3DJ9iyyvH3JJMfnqiFZc
	 ov4WVafUU4xxVuLHVRSSXthA1+PFRoKeBS7deKBoCLYyOUv2iLKAgfri/InkQV4fEcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxRKCfov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38BD606A32C;
	Sat,  7 Nov 2026 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxRKCfov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D7A1F0089F;
	Sat,  7 Nov 2026 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062693;
	bh=5qzxQaHQUywBIFayMqnwZ8mlLxFfBt/w4FePMd0tilY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxRKCfov/U+4/CasLKadR8PU7cQt4YiVTqeCJsmh6xFFR37qajbHfQqNjvKCeMypV
	 3Qg9o4tfb0oaLswwmJngkhTIcbY75eLwj4YIR4HJc/la5vsQqG69sLbIf9cpOgsEwc
	 cmNXKYWJxQk4V+y/fzhw5GNzJIpiTDV5Wt1OHu/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/869] rust: bitmap: fix intra-doc link
Date: Sat,  7 Nov 2026 08:45:02 -0500
Message-ID: <20261107134852.763828223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

`BitmapVec::MAX_LEN` does not exist in 6.18.y, so `rustdoc` warns:

    warning: unresolved link to `BitmapVec::MAX_LEN`
      --> rust/kernel/bitmap.rs:24:25
       |
    24 | /// This also matches [`BitmapVec::MAX_LEN`].
       |                         ^^^^^^^^^^^^^^^^^^ the struct `BitmapVec` has no field or associated item named `MAX_LEN`
       |
       = note: `#[warn(rustdoc::broken_intra_doc_links)]` on by default

Thus link to `BitmapVec::new()` instead.

Fixes: 37f45fe068e0 ("rust: bitmap: restrict bitmap length to at most i32::MAX")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/bitmap.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/bitmap.rs b/rust/kernel/bitmap.rs
index 0e5e825aefb6c..a00988bc8191a 100644
--- a/rust/kernel/bitmap.rs
+++ b/rust/kernel/bitmap.rs
@@ -19,7 +19,7 @@
 /// Must reference a `[c_ulong]` long enough to fit `data.len()` bits.
 /// Must not be longer than [`i32::MAX`] bits, so offsets and lengths used with
 /// [`Bitmap`] functions fit in the `int` and `unsigned int` arguments of the C bitmap API.
-/// This also matches [`BitmapVec::MAX_LEN`].
+/// This also matches the maximum length accepted by [`BitmapVec::new`].
 #[cfg_attr(CONFIG_64BIT, repr(align(8)))]
 #[cfg_attr(not(CONFIG_64BIT), repr(align(4)))]
 pub struct Bitmap {
-- 
2.53.0



