Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208673;
	b=QIKifYQC9lRLXt6s9Cg5gnNeIgpesn8C2AdMT3ax3FPAbD32zRIoMRhy9jkqqdlNzLwq
	 KaluqJGauPNXtMbr/SeqjBqCX+9RGlD80PbW98GmSoig+u37H6HHOlSd7ewPmmERMC8Jb
	 oAB4i5a44uc29v77SxRyZdl7urO6wuHMOEyPJFlLN5mfC7q5wPIK3/WeedUb3GZ3Ui63H
	 KRg7KOUJm9xvx/nS7dNDdNuhkFyxZgre60oJdn8Ax/fJUacjuh7B/aqTZaf2ygtOD6VcF
	 Ku43bTEgeVoYKe0+QHcfYWAIEI0vU36aCa3sa9acNmnN95MtdDvG/WyFBNOZVe3lHYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OZw1+MJAWg2GuitgpeNaV9z2EbIhaXRiFXlg8kdWxMA=;
	b=wBJe+X3iHzW/50/PKGKINleG8TjPKHmESv08W1e+IWQhk5aYSc4VbfWHmJ6BzC0Nkkn2
	 sAT5q8ahOB63uVXIuOI2ey/h4cVdBhqm3vkhg8aa/wDBLvycPLzORKWMSVS61FkRvcej3
	 u43n6OIA8Zq2I0Hybp/BFuRi7uNBs3+tsaQVIXxrsUnm4+heH44AHV+PnynxvkiEOSyVu
	 VytxACdWkDvObOvALK3RRulEhSAldv/67yfLeILbpzb5rYsSrzT1a2iYefOTv+PhODsYe
	 MuI5GnRzhZMJ8Hy+Nk7QCGfF5wpEpeJmySvHQBS9hPuY0vQ/8RxX+OL0TasPRb9dCMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhL58GBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4FF606A31E;
	Wed, 28 Oct 2026 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhL58GBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08841F01825;
	Wed, 28 Oct 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208673;
	bh=OZw1+MJAWg2GuitgpeNaV9z2EbIhaXRiFXlg8kdWxMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhL58GBlkrri/vFE9sLnz//6KdRybr8vtYbcD3RfNbc4Z7d71GFDWP+cQr2PNZYfm
	 +X6+sMLxF/zuaqlj0uwcuEXxlGgRB1pQneVOL9xvAtjF7GaGD5PPa+n/OLFLJmlD+r
	 vjFUgwQ0LIRL/avhh+Vv/QiAQAfpKA9vuKwQkJKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.10 203/516] tty: vcc: zero-initialize control packet in vcc_send_ctl()
Date: Wed, 28 Oct 2026 17:55:55 +0100
Message-ID: <20261028170008.311739553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit 1f71f565e3585da1098ff19ca3c24687dab59185 upstream.

The stack-allocated struct vio_vcc pkt was partially initialized,
leaving the tag.stype_env field uninitialized before being sent via
ldc_write(), potentially leaking kernel stack data to the LDC peer.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-1-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -500,7 +500,7 @@ static ssize_t vcc_sysfs_domain_show(str
 
 static int vcc_send_ctl(struct vcc_port *port, int ctl)
 {
-	struct vio_vcc pkt;
+	struct vio_vcc pkt = {};
 	int rv;
 
 	pkt.tag.type = VIO_TYPE_CTRL;


