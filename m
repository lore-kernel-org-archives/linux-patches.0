Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064101;
	b=N1t5U3ZEx58dbxWsgzXyMZQuOkKjUPxSlZqZ3HiMRJrgNuUWJc2QeeD3oxuUFPIOvAz7
	 S/GqKESkWj7MGGhx0SBfh8RI7mYEDIKG3VeR5iV31cz4EWPaRSZfiRfJNDgOnqEhxmTyP
	 2Z6A6HXZAeMcQHRdpeqFhxnzobjmIkgTRYXdeA9H4ZVhzeTTSxSc4K1rwXL1fugRSShK4
	 CSAujELhSh37s7lJkaQCOuV3HmLPzllLbAaHnTSADxqVpVNaFq5WDqKvOs2TpP6icOaOU
	 nrhLapjNgiICx/jbikGrmsfAIvMwcsnGV+O+pmU51SnYcUXcVoJ2ppGjJx3mmetL0Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=miDq9q7Q2FF4EFMv5TItnw6+4nTAjiXk0wxBjvYQ9ro=;
	b=GllgMpQ5p23Q4c8wCLshS0ULr3480IoqLIgZkAWyPsgNeqFR1AQZtwmByWbBcVFaEjf5
	 YmtNn9QISJOOAbMH/E3e0EHY5xHl5UWA3CMZjL1DLgbLgp+PF1PX0vOAGI9Kmq0w5jsb0
	 hi0OvEKNw65FWRasX9aAnW8W+SOOodGBogymK4glfp4bODhdtq2olPvuq+aQorsjkQcug
	 +mlFtPMjiNlWXEbQjaExPYywSHmn3eiN6xOuRbU2LRsykSxREej6ji5Scnr77KkWT8nuC
	 YdYQVVnwFUxBIGRiZSDiGvQCMlvH5RpV1uIQegC8qrGG+irZOywlLI9x3uFJaa4Rmiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNB0cfyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB12606B889;
	Sat,  7 Nov 2026 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dNB0cfyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270B81F0089F;
	Sat,  7 Nov 2026 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064101;
	bh=miDq9q7Q2FF4EFMv5TItnw6+4nTAjiXk0wxBjvYQ9ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNB0cfyxzld5kYJ8oKS1puem3uc+pWNEJU+yqwoZc/MVcyPSDgzT1cg9XzVPGuzt/
	 +ewyaNPkWfwnyul4mM+JUPOS7hyetPWFRHK9vumWdXpFmyjGvNSEJdiXA9Mk9yXo+9
	 53ZxCmZ+jiYCeuo84H/sCr6/37dLxEYryqcCZ6uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0262/1257] media: go7007: unregister the I2C adapter on USB probe failure
Date: Sat,  7 Nov 2026 08:42:38 -0500
Message-ID: <20261107134946.737689127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 867548d655b3f..dc5b8750a110b 100644
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



