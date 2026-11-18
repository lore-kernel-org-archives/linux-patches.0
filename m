Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034985;
	b=NqhIERED6nIYs/AGAA8sm0J8vvV7iCTAj+L5AUOW9L7BNxGpPzGzpY3py2lqBw9HmrlD
	 iWGpPtdWjqSr1+kpKefQbfP/jWbY33/lvEUfx84m9kquxRXT8mX8WqUdjg6/GeheMQUA5
	 ISpK07cTOzrYCwm6nIozqrFGVdMQxK9P0FjOwdo5xIYRIkng92fwwdpnA1ZSrhYS6qRGW
	 2GuvLEpYo2tLKH6T2J/u2SS9YqpOrVvfNHj+0WoqkHdAjXuPdMFe6D6IZQvuCGt4x32LB
	 CcDtVjgEhnHHVoeku6fw+5d9za1ugVDeVuIr2QC2WlPphXHHCsPJTRiuhTCCoUpJmKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mXCaPe03e+xqpQpV0jPHNw54PH/NUuc8qYMritwE0ZU=;
	b=d68g1Nvhd3d+7WgAnDzKH3kCsh5ZaPFf/j3DLs0ueVd5zt/6Y5osVNAn2FztiRkRLxZa
	 3fEDqk6CcZFheT8L5k+XsmjN0Ow5dwoL1D2ZC7ZckRMEeaQYtueRggB4D/HAYHkHOhkbC
	 sFuqGyLaxpJ3RFXTnjeLCagBh/mrcD+JCM1wXy6cOWQop+qJ3NZeUWWd+4OZcT1c5vzVf
	 l9CGd7jxnBH//dLc+6c6WHd9sJ2lxc3kAdA8vV6FefdNyfmAui963TrjYpcuJ4ajmkYl7
	 rUfuGNj20wrOGumKuJS8rN7922UQxBM0XN0pBzP70VtxzMDQuf3SwziUSbBeyawkCLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jC2gJ7eH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7361A606A31C;
	Wed, 18 Nov 2026 20:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jC2gJ7eH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C655E1F000C4;
	Wed, 18 Nov 2026 20:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034985;
	bh=mXCaPe03e+xqpQpV0jPHNw54PH/NUuc8qYMritwE0ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jC2gJ7eHyzmHEaCksVDIrj1JLsRron7pHG3LFhHgmDM4yhWxGFtgN5vctJmnl7psX
	 VLCUpIrQqe/41FtZlOiwMAsFSHl3MswtkAu4JxOF97vDLuN6+B1SDv5N2rBNSy7Giy
	 byczWGiFdoZJvwqkokY5+h2xgmKUdd7MxAy8K45E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 0564/3318] backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()
Date: Wed, 18 Nov 2026 15:19:46 +0100
Message-ID: <20261118150334.308652589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

commit 1dbd46d4b2fb416a8202b1a8e4ef9d0cadbe075f upstream.

wled_probe() doesn't set the driver data for the platform device.
As a result, platform_get_drvdata() in wled_remove() will return NULL,
and the first dereference of it crashes on unbind.

Set the platform device driver data in wled_probe().

Cc: stable@vger.kernel.org
Fixes: feeab87b3072 ("backlight: qcom-wled: Add support for short circuit handling")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-qcom-wled-backlight-v4-1-bab8c7ef73cb@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/qcom-wled.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1682,6 +1682,7 @@ static int wled_probe(struct platform_de
 
 	wled->regmap = regmap;
 	wled->dev = &pdev->dev;
+	platform_set_drvdata(pdev, wled);
 
 	wled->version = (uintptr_t)of_device_get_match_data(&pdev->dev);
 	if (!wled->version) {


