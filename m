Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057961;
	b=ZTp502pJTMdv1f0+wibe8Dz4Ggw25kNbRGWHqcaVoFlhz7pcWYNpmh0LxNM8rlXBUhhY
	 jqaf8dYnIfU1mkTWA0tmCpcQpojmc+Ysu816okLdFV6dvtHcewnxjLvo6RK/DOQzxbK3T
	 JzKruzNft/kdO9juaPyJ2HMnKUex74pqpA9jgt7qhlnpq5/0EaFrvJfGaX1rZgasYtT5l
	 LxdC59CtGNIug/pkbXj73ms0aFhRQhjKF7IW8S7RhzTrdSHJan6fLtIAQdogKTtSs3+Qv
	 hB13tGpu4XDQp0FPjDLHpgw01XZA0HT5DJsd/3EVMOlGN4KUFtHkwFSQogG7JUR1RrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fOGUIpm37FZjQ5ULWvRX+SlZfMeFR7z9fQl+dde5uao=;
	b=E7Ueq3faI9Mw0T9L3E4AHlbeYGMqkmsfERC3gMX8SIUv/xdNqPCQNGP5h5EAOZDkTGD/
	 NuzoGKdizsx+bH1MH5nHvPV9C+7gxgchuVL3bCbrJvwyZStYhAiI2jdMIB0185QfM1Tmk
	 Uz5uWhB/EjK+OlSZze7gwPVlSAjbH6r3eQiZjCC0dXYXaN7gTdtCONPc7Ey/bMLqBJ9ab
	 b/l3YEJqKBaMzC+l8T7fZJI/SvVGVLP7tltvWgQo0fWRcbxxpw2yGIPNo+ruVDBcDS50u
	 Zrkh84cRs5mrvT9yPDSofq88H7zQOiimCIoNSm8eX7FSzqReX3RMpxr1/vlCttaqPWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3cNQt7K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581FA606A325;
	Thu, 19 Nov 2026 03:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3cNQt7K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A981F000C4;
	Thu, 19 Nov 2026 03:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057961;
	bh=fOGUIpm37FZjQ5ULWvRX+SlZfMeFR7z9fQl+dde5uao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3cNQt7KC04CM+nU/SJFqa0P8nGuvQJy7GcWsF+XRWstm1BcMum31NXOhjHGPbPEX
	 G0PqS7UZPCiJ3K4Pvb7seuMrUa4Vv774shD+w0RXXNoGoV0c1Tgq5JfpqFTEIv7FI/
	 y9pMOA6Gv++TAEdqmW76eE5a5GykgrusDkVJ0PGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0317/1848] HID: roccat: kovaplus: reject short button reports
Date: Wed, 18 Nov 2026 15:39:15 +0100
Message-ID: <20261118145925.469924546@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit e95917a606f486e46f5136fc1b72190742a091d6 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct kovaplus_mouse_report_button for button reports.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 0e70f97f257e ("HID: roccat: Add support for Kova[+] mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-kovaplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -611,6 +611,9 @@ static int kovaplus_raw_event(struct hid
 	if (kovaplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct kovaplus_mouse_report_button))
+		return 0;
+
 	kovaplus_keep_values_up_to_date(kovaplus, data);
 
 	if (kovaplus->roccat_claimed)


