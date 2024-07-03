Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29438174EFC;
	Wed,  3 Jul 2024 10:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003728; cv=none; b=CwUkfKI2Y/Np7Wss0K6FvIaoVygcGkePj3d7KMeFY7AQ0QjpTcIngWJI6FA0uhQ0XbPBsWN3KXSQM1H0mBAfpCp351iXk0u09ZU6Px28fCTyRjSKFtNI1hq/kp6m8j2shfxd/MD/DrUZElSS6laDtCLAiFoIy+Ubxj/Ys+ZRx1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003728; c=relaxed/simple;
	bh=sI6YJ/n4mv5eQzWXjol3hADS6MEfC8zGMxh7dtl8PUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6IAlULnlQ8JKz8nbw37HbpQZgfcMf69kVcm5XBlZACPgxe22pfL6WjQS6DyHpa5fuKiEi3NcIUgsUSWNmm5J9Oy8DZap329M+DYkAHmVuCZP6kxxASzJT3cIjgGFqRp1V8ywqivyH4ZvpTTHAXKUGkDJ3qeZMTHFsOjOWNidXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUMFP4ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUMFP4ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A083EC2BD10;
	Wed,  3 Jul 2024 10:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003728;
	bh=sI6YJ/n4mv5eQzWXjol3hADS6MEfC8zGMxh7dtl8PUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUMFP4ey7TwzV78TbHSOTNQ25PPMu86+gXPT8uO/eCoD3pZp6kF3Oa5GlOxMP/Jt1
	 oSKjUbq5U5HIr9BD8A3yHuDTEoTZ8xpp4yB2zGoR1C1EwoCtm5AZWTeAGQ5v0l10lZ
	 jVpkMBcUS9uArr/Y14ityOfxtgmSIWPRTuqyUtsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 128/139] tty: mcf: MCF54418 has 10 UARTS
Date: Wed,  3 Jul 2024 12:40:25 +0200
Message-ID: <20240703102835.269586031@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 


