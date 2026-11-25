Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620442;
	b=TPmTMxbDPr09QpN82902Xjn7GtzUwJqjNUYuWQggJKUiP+M4seRu2sZBhyEmzjV79371
	 JVDIA1+lB+GR2aeeC8rSCFO722Au90cpdIxFlcpb8mfdJADoADw2sNC/jfRgauqRpJO4M
	 X7yZwyUQ/BH1h/cZHhi3k8FqzEwMBlmgaFmHCtzqlqtE7gfTih8I8O7cHwh2fjWYCi1RF
	 /t+qiQHBengNAt+lkKGUXZOmp22Nh2vWGE6zPmg40wTsyAw81NYK4jDeQclZX4VSCLLtx
	 nGTh4gMPgDWCmVDNpQqYVOpVk3AypO9mrKFQhhhF+TSFqEh1FkAk8Fx6iTLKAyaSgfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+vvgpm7McGJmQUI6BupaPq8BhUejf2VwAUHqGXWXMZA=;
	b=EdWsVTK2YSu86tmdWVXBTD5SBAR+jj06trPAfb3kFTJmPS78IHa+egDpSj8lEbi2kshJ
	 U7XoqG8St7ztHMjAEJ563vHAS0MGviFho8coYxGoPBm5TEYwuTxQSctdtNp0II6fFW411
	 2rQ+GGQPxht5dFYhSks+WoLOv0Zune0q/ciPh716PfRh2ndU6sHz0hprO1szkrBEAg+Df
	 fpmOrnS+Cu0c42hTCCFEKlaexMwlzMfge8JJLFGQnr5ZftvSD9RnB7+Wpj+MguM8c74pO
	 tzvZSy5nJW7r+qWDdcuMycDUhrn1FEPdp+1Ur4Y84p7Zy898G5nvGPqxodjHbx5KZHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzVE225h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D36606A323;
	Wed, 25 Nov 2026 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzVE225h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117CA1F000C6;
	Wed, 25 Nov 2026 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620441;
	bh=+vvgpm7McGJmQUI6BupaPq8BhUejf2VwAUHqGXWXMZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzVE225hVxTvfA8WZ8Rwr9QQW7fKCqlDSar3CfN6Ar29cO1nW+63v1ZGrYdY4aNjj
	 L4Vfkq53qrz2IolSkQ8W6vOU68KIByCmYnJFUMTac0bM20jnnxkHgSGZNw9D6pJ6Ix
	 dJEb6+16VuhFY+qnWsB9JTeuLHeacqFIbhs4WjaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joonhoe Kim <26rote@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.3 0918/1005] usb: typec: mux: fsa4480: Keep the USB 2.0 switch on in DP-only modes
Date: Wed, 25 Nov 2026 15:37:36 +0100
Message-ID: <20261125143843.195131336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Joonhoe Kim <26rote@gmail.com>

commit 89aaaa26f6985d55676fc5c90440f279733fa132 upstream.

DisplayPort pin assignments C and E give all four SuperSpeed lanes to
DisplayPort, but the USB 2.0 D+/D- pair is not part of the pin
assignment and stays available. The FSA4480 sits on that pair, and in
these modes the driver turns its USB switch off, so a USB 2.0 hub or
device behind a DisplayPort sink is disconnected as soon as the
DisplayPort mode is set.

Configure the USB switch the same way in all DisplayPort modes.

Fixes: c7054c31c1c9 ("usb: typec: fsa4480: rework mux & switch setup to handle more states")
Cc: stable <stable@kernel.org>
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20261022165143.1327-1-26rote@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/fsa4480.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/usb/typec/mux/fsa4480.c
+++ b/drivers/usb/typec/mux/fsa4480.c
@@ -93,16 +93,9 @@ static int fsa4480_set(struct fsa4480 *f
 		sel = FSA4480_SEL_USB;
 	} else if (fsa->svid) {
 		switch (fsa->mode) {
-		/* DP Only */
 		case TYPEC_DP_STATE_C:
-		case TYPEC_DP_STATE_E:
-			enable |= FSA4480_ENABLE_SBU;
-			if (reverse)
-				sel = FSA4480_SEL_SBU_REVERSE;
-			break;
-
-		/* DP + USB */
 		case TYPEC_DP_STATE_D:
+		case TYPEC_DP_STATE_E:
 		case TYPEC_DP_STATE_F:
 			enable |= FSA4480_ENABLE_USB | FSA4480_ENABLE_SBU;
 			sel = FSA4480_SEL_USB;


