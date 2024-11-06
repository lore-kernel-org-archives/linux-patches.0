Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B7A1F4FCE;
	Wed,  6 Nov 2024 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896824; cv=none; b=ZT3ROtl1EvTtIBsBMbSoDM3GMOn+dVMrZObBpS0WwrWVKe/e7wI2P1BkBWz09JJSNin8Fh0FbcDjrkSsghJX7jDrIFY/105c4syb1EOQtDKy1D2FiaT9fMRKl71hlSzXIha0uBnNG7z9LkqcskTrb8Gk7czpk5d+ZakGoYW05Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896824; c=relaxed/simple;
	bh=xRbehLLNjlt5GQF9gKax/awK1jbtcO+44cywhVn3tZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmF1uxKpFwCovhxE2Eye3DUGQS+A6Iadho65+Kk2mck9dnJT4uGqDn2xOedoHCeAVAdTeGtgiVV6fpjEs1gdfkFclz+qoiq4Ww5zOciVr1E33omxCCM8ZQJNYBOyWUr3RiGT8J2H3ZfA6R5OWiqkdY+6489AIMrpqgzT7+1xEfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0JSQeQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0JSQeQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE2FC4CECD;
	Wed,  6 Nov 2024 12:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896824;
	bh=xRbehLLNjlt5GQF9gKax/awK1jbtcO+44cywhVn3tZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0JSQeQ0bMGPzdjNTMh7D5ytNQTgmZqn+EBoJiP4LfEg9SkodV3qCVvV4Mskdbpz2
	 nYEYyKuc5HOyhBA0JRHyXmUN+4J+eopi+pVtpj3huV1wqUcYh0Ref6djJSPfoCJIhH
	 YyCFAVrm/DdJxjr9NwMi8hMltY1Tc7WBrn1y9kmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongren Zheng <i@zenithal.me>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>
Subject: [PATCH 5.10 085/110] usbip: tools: Fix detach_port() invalid port error path
Date: Wed,  6 Nov 2024 13:04:51 +0100
Message-ID: <20241106120305.536900947@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

commit e7cd4b811c9e019f5acbce85699c622b30194c24 upstream.

The detach_port() doesn't return error
when detach is attempted on an invalid port.

Fixes: 40ecdeb1a187 ("usbip: usbip_detach: fix to check for invalid ports")
Cc: stable@vger.kernel.org
Reviewed-by: Hongren Zheng <i@zenithal.me>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://lore.kernel.org/r/20241024022700.1236660-1-min_halo@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/usb/usbip/src/usbip_detach.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/usb/usbip/src/usbip_detach.c
+++ b/tools/usb/usbip/src/usbip_detach.c
@@ -68,6 +68,7 @@ static int detach_port(char *port)
 	}
 
 	if (!found) {
+		ret = -1;
 		err("Invalid port %s > maxports %d",
 			port, vhci_driver->nports);
 		goto call_driver_close;


