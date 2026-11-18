Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057239;
	b=FJJLYycVUeNmYcVZiXxlPR/Cg0ugZlu1TbiM1jPIqSIUajWm/H1D1xSpuZi/2//J5Wyh
	 tV1w5lpcKdB4YOEKKXgQMaZ7H87iiE11OYnSFu05M1U84ssRPEHt+ApiNtT0/o+UtOTNb
	 SPZc0ArmMkxcLAKNn6da/j92if5+H3PpVN9BdcHkKaj8DF/kxm7FebECDn2eacv8UOgmc
	 K0a4I6bJIkS5SDDtPlpsnKS++gEPjCRfFWNxwvZFSt4fUXxXbn39oIH5oescLc7jHoKv4
	 QtIDnhuVIAaITAwxU3ss7ywHJuHIhwwHkFJa6U7NOb0PmyKgv8sDUvRfpRCPa2EVcfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sENhq7SLJSH6KOPufSnWHYG28gHl+hnxTA/5HizR+zw=;
	b=e9s13DBXA7lg2qPooJ0KHTNCCl5zUPy3YzK3L5pSA+ktpRKh0S4AudGp/2YgKmJBz1f7
	 Z4COpQaL6Jl3SmkoRFBu+eU9HIKcEp4KUgD2QRnGrnIP5lT/G2QaYuLbZo0Zgi8DL0ZCl
	 wvFF2+9vvlldYQeHgdyQw7+ebypKkrgExgpub2u0sK5Gz2p1uou4zsbxXpZu56YaQlDPZ
	 OZI+X2LAALF1UF4WNZlWhx+Qgi6sHYp6XNh6V01+YtSTbifb+oC0And6cLjE7k8qY+hHg
	 2AJ/AZXUa91RwI2eFIzpiOgbH2zX4+9UODdOR/alaj/1oakuykKOw5Kqe6FaHbfUhvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsyjPVMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03A606A31C;
	Thu, 19 Nov 2026 03:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsyjPVMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3645B1F000C5;
	Thu, 19 Nov 2026 03:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057239;
	bh=sENhq7SLJSH6KOPufSnWHYG28gHl+hnxTA/5HizR+zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsyjPVMVW+oEUqhY7bHmBqMa/x5m4tk7YzAJB12OXOrsXsNX039A3V3rxjzg88CSu
	 m1trQLcqO5gFvOors1gOQru0SaS8UM43nMNoOmpSRLzh2UdKw+9JzwMVjnQVy0+42n
	 LoMoTtrNofk2N9BZbzUzUAZSjLQvHlZ2fFOZD3Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0061/1848] usb_string_copy: Use kzalloc() to avoid leaking old data
Date: Wed, 18 Nov 2026 15:34:59 +0100
Message-ID: <20261118145913.674533676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 057df423bf4747091cf942af57307627e941e1fb ]

If the string is read while being updated (which is why the copy is done
in place) and the new string is longer than the old one, then the reader
can read memory that isnt part of either string.

Use memcpy() to copy the known length string instead of strcpy.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Link: https://patch.msgid.link/20260608095523.2606-37-david.laight.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index e00762efd6da2..4cc4dc8bd839e 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -114,11 +114,11 @@ static int usb_string_copy(const char *s, char **s_copy)
 	if (copy) {
 		str = copy;
 	} else {
-		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
+		str = kzalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
 		if (!str)
 			return -ENOMEM;
 	}
-	strcpy(str, s);
+	memcpy(str, s, ret + 1);
 	if (str[ret - 1] == '\n')
 		str[ret - 1] = '\0';
 	*s_copy = str;
-- 
2.53.0



