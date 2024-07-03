Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CC7173352;
	Wed,  3 Jul 2024 11:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005200; cv=none; b=umOZticaGEngnYAGL9VBwvxGj9P5a06A4SErf+v4dIcTjSc9/783gJjcSkbGkLyGrVoPL93w3iPEmBCmZS+KNmjqjDja2wNXY7UpHI7+RGwrdQKYyrtEPfRoPeYf9hPPfGBweu7eF43sa4jPP39jY4M5wyHOpV3l0VovC1fcaFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005200; c=relaxed/simple;
	bh=Xsk5/7V/eIf7LARsTt0goozh+K93hSPDOEMJ/s54YW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unV+FaJKVUOOg+5G0FBLoMKZ1jStD5RzoV/hrhT3XviFfEAhvaeUs2W/DACSI3RlYy2MO3z0/dw/gwCvb9N0IEfqpn9SYWpEnFrh5HS0lwv1D9k8q3El6U4MXzy8ro7B1yjj7i5eMMksVRGvrFr6eNNu1F8DMMGvjQu3HgPd6/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ct66juEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ct66juEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7B2C2BD10;
	Wed,  3 Jul 2024 11:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005200;
	bh=Xsk5/7V/eIf7LARsTt0goozh+K93hSPDOEMJ/s54YW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ct66juEnLeJ1kjh4dJNDcsFZVX9wfHeK/L0KL6drBLmTQZYA2J8WzNvPJRnBCEd3B
	 L8/+aIurOO6yVl5xCtKnKcvjCe1bTajTfY8afh+09WAj5xbxpXDzOl5YXsfrvKYdrQ
	 LcIhngEVtUB4/yKMnFJWglUeJPMOblweqNL8gLGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 260/290] tty: mcf: MCF54418 has 10 UARTS
Date: Wed,  3 Jul 2024 12:40:41 +0200
Message-ID: <20240703102913.965387201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

commit 7c92a8bd53f24d50c8cf4aba53bb75505b382fed upstream.

Most of the colfires have up to 5 UARTs but MCF54418 has up-to 10 !
Change the maximum value authorized.

Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Cc: stable <stable@kernel.org>
Fixes: 2545cf6e94b4 ("m68knommu: allow 4 coldfire serial ports")
Link: https://lore.kernel.org/r/20240620-upstream-uart-v1-1-a9d0d95fb19e@yoseli.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mcf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/mcf.c
+++ b/drivers/tty/serial/mcf.c
@@ -479,7 +479,7 @@ static const struct uart_ops mcf_uart_op
 	.verify_port	= mcf_verify_port,
 };
 
-static struct mcf_uart mcf_ports[4];
+static struct mcf_uart mcf_ports[10];
 
 #define	MCF_MAXPORTS	ARRAY_SIZE(mcf_ports)
 


