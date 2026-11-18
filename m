Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028434;
	b=IMZxOO6umZafPaDJ8nr/0QNcKxTxs0KcrTZgUFX5y026XtG2HA2d8+3tIgTgyX3sRW4G
	 qVOWX1vtVhLW8eTIbyPDwAHh5tBCksV7gdU0bHtJDZ0+y+zfQrBSptFtgbf8wvjRs+ygl
	 v+BAM6q2iD1yGoh1JPtqgKxjxDLvbxaBJc4RVsabDUi22Ivv2XaHie07Hi+AbO2E0tKDd
	 HsPwgQzr3yz+RmPnSgejy2V9UZpeLnj/dzlofEBNn4qvDfOAcd1wR2foJaCZJmishVvdo
	 +ZhBcEJVcMzGEO6HIQQ7bkCl2ofARwzw446n5dlJ6p1+FLwC+cZw/9Ov5WRU2QsVoIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UnHRRNOLl1L/e38jxV5AGslyfalfrQfUS6fvJTNYkG0=;
	b=ew7EiitlsUb3i3+5Db4Qw7iq1oTcf9f2cygfEMXLThbHttBKsGK7HepRgBAlAgoe8NRZ
	 MiR25TBoKen6hlTaMntT1m0R24whhWGK8dDlDILw64W1lApTyqNIkqAKsqi4KEZTLkxmY
	 UA3PTpfG0DQW4DJH+Gg+K5dV+mJgC5Ij+kdF1MU+gLZizGbdkNy6aIKsFyU2wF+GQhYB4
	 QKncMh0nzvvziEb9cAXmRzs7rirmYj+9imPknLNoExiAUKraDyiDf7Bxz4bDhRF04mcv8
	 lJrnBVm/eYhQtrj4CD/1GSmnhcjCOhPh3P1s+Ub4xWsBT9ecaOELoi2LIed5bhVB5Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dOa/C2+g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A397606A339;
	Wed, 18 Nov 2026 19:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOa/C2+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCA31F000C8;
	Wed, 18 Nov 2026 19:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028434;
	bh=UnHRRNOLl1L/e38jxV5AGslyfalfrQfUS6fvJTNYkG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOa/C2+g1IA81dsYb1iS5uCeLGGQzBz0rtQSbx5kBOxohV4nLlR75+bnvGctrVibk
	 YGfrTe0oigQOjcOaEmgVNabdbwzNOQAmfnAwQ2AWilu3PgLMl2YPW+4BlGVu6o2yiq
	 efgEYIGISWOZ70kXtPtEtIpZ8FMpDRezszXvUsQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 2144/2151] scsi: scsi_debug: Add missing newline in scsi_debug_device_reset()
Date: Wed, 18 Nov 2026 16:04:39 +0100
Message-ID: <20261118150239.769666828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

commit e4bb73bf3ac11b4a93634660345b9d764a4a80df upstream.

A "\n" at the end of the sdev_printk() string appears to have been
inadvertently removed.  Add it back for correct log message formatting.

Fixes: a743b120227a ("scsi: scsi_debug: Stop printing extra function name in debug logs")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260519205356.1040855-1-emilne@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6939,7 +6939,7 @@ static int scsi_debug_device_reset(struc
 	++num_dev_resets;
 
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "doing device reset");
+		sdev_printk(KERN_INFO, sdp, "doing device reset\n");
 
 	scsi_debug_stop_all_queued(sdp);
 	if (devip) {


