Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062945;
	b=PtqUPQy2ytTjunofdnn3WcspM3iWD4M5f12QQBYP/h4hvdhh2GSAr7822SZThAkbRZMD
	 +Ro+uKr8kuB4mbHwDqBZsF+EtA4O8+TVmVqU2CMHPtH9dbu7oSreyOScsi+O/VbFxLBS6
	 UXSM5PgwRkO9yFpwhx1+3aP/Rq23eZR6epk9ve7/7xX4l1XI5u3+yjcrYzwrItfVduI1+
	 cG+X90ByqjY86bUzNAHtC2hiCvszBFc/z3syxNUV0+02kN2Qdir8QDDAliSqCsCNHRPen
	 yYMRUl734Cx2xRgR+l+uhm1wxov7mmOk2Ed8Yes5H1UaSR1MreCFhjHXTQzdQlNTU7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0VqrGiuggtyZHaD7ex0tfwPI4ijRtbILZw3ntDQuKYA=;
	b=TZJQdeMDjnCMQtPoW+uWKGIcDwjNNPnThZ2ruUN0/81xGRF/uRc+11qVGB7QIUdwUzFU
	 RS3ME0F/5qI583zIruIsbryguzGNbQT32gFuRvYj85UqbFhbKOTlC3CDnHuMcns5QY6uj
	 CrzhpFOx3MsfDOUn8rYJDv+f+5d5p2o0i/g9vq72LBNgXsBrWYSDUAsuPHGeWW5x9CiYc
	 Zk/wzTZOKb/Moyy4t3uFrrHgvuya77Wes7l5iZtVI2G+iO6QBnnj+tPMWODCdh5fqUgin
	 sApzycAbv8h2M8shpboLK+FDg9HuT2YO/Bl65t1zhv0K8Q55V6KM9RWJ8Aeg2KBn7kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ga+eQE93;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6620D606A330;
	Sat,  7 Nov 2026 14:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ga+eQE93
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134F51F0089F;
	Sat,  7 Nov 2026 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062945;
	bh=0VqrGiuggtyZHaD7ex0tfwPI4ijRtbILZw3ntDQuKYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ga+eQE93p7I7vwlSa18HMRut8RCeJuY5RVgb6w/QZiCAB/RHj3d8ToiDTd+Nz6eYw
	 Le4nk63Qc+PzV3QzzzEXtu3Cl/VItcEp05B5T6MegCCNhCOG3gwWi+sg1Cx75i1W2Q
	 87EIqs3swsodBBJMU+LjkgW/Tkod3IoR31U1OaHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/869] media: go7007: unregister the I2C adapter on USB probe failure
Date: Sat,  7 Nov 2026 08:48:13 -0500
Message-ID: <20261107134859.117217459@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 14165cd16fa7c233aec6a407b56b304e7a283911 ]

USB probe failures after I2C adapter registration free the backing
go7007 structure without unregistering the adapter.

If i2c_adapter_online is set, unregister the adapter before releasing
USB resources so that I2C client removal can still use its callbacks.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 59aea928d57f ("[media] go7007: don't continue if firmware can't be loaded")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index bf3cf320b2c9c..ad9cc44660dd3 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1326,6 +1326,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	return 0;
 
 allocfail:
+	if (go->i2c_adapter_online)
+		i2c_del_adapter(&go->i2c_adapter);
 	go7007_usb_release(go);
 	kfree(go);
 	return -ENOMEM;
-- 
2.53.0



