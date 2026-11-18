Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017300;
	b=39FqMsHeEkhyrK9xxP/pr0gWalPgy8hj6xGv0eyXATS/cC84oEwcL3RHgIPuB63GMbou
	 D8OoAi4iZOpI08HuR7gxZGgZkeu8jDUo5AJGIAafNe/osRvpgL6l9B4kT2KullAqrQWdi
	 dErfiWSVB9ZQry7y0nTJxQFh0canfKdyUYMHSteqWY2qKKnFkGSxNu8QdtLRqRnRbN1Hm
	 9sdOME/Z+FGxEJ9JX1XHpYVexsi/keF+gwVWxo6VHYLgcno2i3N1ykkVlJzoN6QZ6q/nO
	 YbvZMkFbuDsHRf46XZMcYVw1ZmJrw54+xfZawhjN1Ujf+hWouX+bmhUcmYckrbJrd4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8eVD56aA87IgDLcxwAzfXUBaqPNGNcwVQaJALcE7F4c=;
	b=qHhX9dX77/DuxJk07hd4rK5oc0LENmrH89liqUw1QwyUdCfnXl1cpw4SGxM/8NSXb9jm
	 V5AAhO/e1RqxVAS8izCLPYgM7SaZAjccVlonsVbDs86QMKrUxA/liVBU92OD82LAIQB2p
	 qHfIbDKNQ+wGoYDEgIAsDl/qEceuFI8JH4/X+I/nrGJH5wIpdxYCK2kz5tuUkIYhOP5eO
	 CTZGdV9uJlAvHRMKlfBYoASASAc8Xbkj6qGy+o33i5pJLe3/4YEQU9aYCw/MFTKAllWua
	 /N+VCq9GTK7cRyj0LZT/SZ7YqDrMo+yg+82Jqmu6rK3wR9dNRuDY/AZkJNIjuK7uirg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqcGeckh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ECA606A31C;
	Wed, 18 Nov 2026 15:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqcGeckh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970111F000C4;
	Wed, 18 Nov 2026 15:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017300;
	bh=8eVD56aA87IgDLcxwAzfXUBaqPNGNcwVQaJALcE7F4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqcGeckhfnMpvqkGY8UaK8q/Qe4c+er7Tfw6/T6bmjANFjDdXUIGKwUsYRrVtuky+
	 zd0/yPUsZgHdphJq2pfBave5Dg54xO5OUSsGn5p8FhWYn5R3G6b+CiGzEZ7yjngGeZ
	 1Y+rpXMgwsh0uaTNXP62eKO1/43NZRgfMzKy/f/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0836/2651] arm64: dts: qcom: honor-magicbook-art-14: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:36 +0100
Message-ID: <20261118150317.976304145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit fc29959413b0e9f7a7d4e1ffa02fa2465461a6f2 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 21b15fa5f8f4 ("arm64: dts: qcom: Add HONOR MagicBook Art 14 device tree")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-5-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-honor-magicbook-art-14.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-honor-magicbook-art-14.dts b/arch/arm64/boot/dts/qcom/x1e80100-honor-magicbook-art-14.dts
index b70c1e094bbf2..a14f0d0632f09 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-honor-magicbook-art-14.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-honor-magicbook-art-14.dts
@@ -1068,7 +1068,8 @@ right_tweeter: speaker@0,1 {
 
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
-			       <44 4>; /* SPI (TPM) */
+			       <44 4>, /* SPI (TPM) */
+			       <65 1>; /* EC reset */
 
 	tpad_default: tpad-default-state {
 		pins = "gpio3";
-- 
2.53.0



