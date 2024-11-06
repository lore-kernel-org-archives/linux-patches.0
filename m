Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91D1D2784;
	Wed,  6 Nov 2024 12:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896156; cv=none; b=EXunIf0uR8AklGiWcjLrj1Aq+tFzGq41mFF6mm4qk0mVGLLSvWwaabTjHc/UurmduKgNkD/m1UfDrv52Lk2ItFXHm7TwSj0gabRa/Zhp3iEhTzhwtAT0daGZvV02B10hFMT33qOxP6kopY7DDo02jwrztTGucOoPbNYjc0P7iDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896156; c=relaxed/simple;
	bh=+oy1uQ5H1IFv8zk7JB21dyb8GtcFlWM+rtvjsui990U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpE6XwlywEmb4SpSfT9TDWj3r4bBWb3JRpa+fe7JftZ0FpWSL7QU8HmuPJ8i0HDSpU4XmLNuV5khhlcXYCBfEWU/K+81CfaWPgKyAGT9LaodnyLCmnFACVsL7iyH6bjoyrY8VKYNhIbTZsTbAK4LK5dz9K3nQhoCUMDlztNGiWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r76Qf4dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r76Qf4dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE46C4CECD;
	Wed,  6 Nov 2024 12:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896156;
	bh=+oy1uQ5H1IFv8zk7JB21dyb8GtcFlWM+rtvjsui990U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r76Qf4dqwj+/qZkuSGC6l8j5wx9c9tGX/Czcb5/16jevz/8NBP8rPYO7dm4QvOx6z
	 f2c81IeX2Qi04xshnCI60QNBYho6XaOxMVqZIZ6jEahf6JMZ6j6ffLiH1mlXwOajWS
	 fzp2cm9ZYE6oB4zL4k5oyYB+X5j1wwTrSQt26m9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongren Zheng <i@zenithal.me>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>
Subject: [PATCH 6.11 107/245] usbip: tools: Fix detach_port() invalid port error path
Date: Wed,  6 Nov 2024 13:02:40 +0100
Message-ID: <20241106120321.850390464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


