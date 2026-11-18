Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047669;
	b=5APTV3usfBza9RJokinYySGz0PaistJzv87eOIDtMBVhibYttt8dKw7RWscq3+/pL+ST
	 Yz85/Zlq3kjuVbXUyqVHzoA+uQxr/7jII9QDsn4Rf1u+16RyvXRiKN14p7Ex2SJsJl6Ru
	 it3xlJy/rIShuMBpiKk1hH0LiLKm+kAkzB1OQt6u6QhpV6/lTt3kbGrx09LHywIAqdax1
	 vbRmvvt7buGTa0Wg9Vp7wdflVY9roPlqyIp5OoiO9cW9XOhSHsvOTKrFOevjZRHe6RVMu
	 xLyaZuqUprRuw96ucdcWuU/gPqPy+W3/lCVwa0vUNWn2pu2YcsBw2UhkzulQi+L2iFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CtZlAznaxmXub/V+lu6vpHnMCorFgxHng/YEFIVWJ6s=;
	b=LgcEg1IR4XAHp+TMudN04/G4vGn7PRh/EO7pHCG2hvmK3HxYoa80iy8UJiVXL8q9Q7x1
	 ntYs/h8X8dxBr42D8WgoHqxk7ualP1UnQCSYhvLi1fnQndi2CJ0MN+/f5+2UOKd7cnLNv
	 83kJGBZ81oC7msHC6mG/YZ707K1X2kzgMFysXfNJs4piQ3jUTu3GwiuA7EZ5p14FLEy8i
	 hfT5ZUJjsashR26y1sW95PLz+fccGiWNbhzVHETn7/CvTIJ33oSUbssETimoPnKF5VgQf
	 TAat/5/KlZ9+Px6NeB44G5njqlvOwKiMGnWYQQoeIRaIx/t0oVIOcm4M2HoUu5AgUtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2+4anQ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1CA60A2602;
	Thu, 19 Nov 2026 00:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2+4anQ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A4B1F000CD;
	Thu, 19 Nov 2026 00:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047669;
	bh=CtZlAznaxmXub/V+lu6vpHnMCorFgxHng/YEFIVWJ6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2+4anQ1q011u4oIXyEyStEyGLnPP1OkayTaGM17BsynGUWSJnJLnRC78DnASzGNc
	 2KbJ0wNKMNo88CkUADKlkbotY/6Zdrn9wmS/yA5XI8SAGaeLUpaL62i4mlbCal1Pol
	 bYsEUFQKJfK/LENYfenrNAyctajUk7lUbBRNU6hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Zi <2959243019@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1720/2857] comedi: addi_apci_3xxx: fix subdevice count underallocation
Date: Wed, 18 Nov 2026 15:45:54 +0100
Message-ID: <20261118150303.254390101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Zi <2959243019@qq.com>

[ Upstream commit 3de5aa458dede472a253266d02902bd95af8e849 ]

In apci3xxx_auto_attach(), the number of subdevices is computed with

    n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao + ...

The ternary is inverted: when the board has analog input channels
(ai_n_chan != 0), it counts 0 instead of 1, so the AI subdevice that is
actually created is not accounted for. As a result
comedi_alloc_subdevices() allocates one entry too few, and the later
subdevice initialization (notably the TTL Digital I/O subdevice, which
is populated last) writes past the end of the allocated array, causing a
slab out-of-bounds write.

Flip the ternary to count 1 when ai_n_chan is non-zero and 0 otherwise,
matching the subdevice creation order in the function.

Signed-off-by: Yang Zi <2959243019@qq.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20261014101803.11036-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 656e39fedcf0 ("staging: comedi: addi_apci_3xxx: only allocate needed subdevices")
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/addi_apci_3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/addi_apci_3xxx.c b/drivers/comedi/drivers/addi_apci_3xxx.c
index bc72273e6a291..7355ec454cb40 100644
--- a/drivers/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/comedi/drivers/addi_apci_3xxx.c
@@ -787,7 +787,7 @@ static int apci3xxx_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	n_subdevices = (board->ai_n_chan ? 0 : 1) + board->has_ao +
+	n_subdevices = (board->ai_n_chan ? 1 : 0) + board->has_ao +
 		       board->has_dig_in + board->has_dig_out +
 		       board->has_ttl_io;
 	ret = comedi_alloc_subdevices(dev, n_subdevices);
-- 
2.53.0



