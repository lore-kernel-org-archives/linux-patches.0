Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617824;
	b=sogQytRBxGUW2DFEwb8WgkX6QEcHHL5fpcULzPYXPHHIQla6IwZlE6hhC6tag0HiwcVz
	 64b9y7CexciEtCBD93ks45sbBO56VUHBBAIZVjMXmzd2potqt0LlTaDIhiiPK4KgsZUEl
	 zyp/lBlLBQnw71dKv8fuveQpXdu7O+kgdv2BapndYh2s02KJ8rRK9xL9rihol7Rssx9Bb
	 gq6yfbypWuYPcq22DhbvmqXOiaFXYxuyQXIuJhFVBWQ6FXpVnHpJjl0RETGogdZw7bETY
	 e4+lzbwP9qj7xP4vy33ISGrrnvfyfifoHt/lkURF+FWqzu0ZVOmRS02SAtWY2jf5clg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJ7cf2kmfDwIBowzcOT0QD3wvowcAuosaaJnSUyMZHA=;
	b=bDklRHosx9xeVLHd8eMBC/e9jnANOdptFv4ewBoM2ArOlC5ybDjTh1g10LTKSJFxV63s
	 FOfjbbLwcDlt+5tz/lAc6tkWro71M5bBRG1Mz6UUstsxtz0nGTQlULhByIPVz5cs3/v4u
	 ANnsMVQg9KHAZvFALxS9QwvZONAhd11/6dSl7NxwN0HLwoy8aCJ2Tjr3seLaqxVy2L11o
	 4JrHLNC+PMzSs3cbzWVlEv8mupYVkRjmDKbck8rfbwIy9RiW+Go/insSe6B2b9PatjM8n
	 0lC8Y0o763q3AoJP3Os2bB13DN6Qv1/fTULZNtdFIpLRaQ+wTb3xMP7yiMGkeA4vuzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEjGXW1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33CE606A31E;
	Wed, 25 Nov 2026 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEjGXW1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57741F000CA;
	Wed, 25 Nov 2026 14:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617824;
	bh=EJ7cf2kmfDwIBowzcOT0QD3wvowcAuosaaJnSUyMZHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEjGXW1bRe89z0diqJlGv8dz+VHEZOKvptDoy+x1i+GZHzZ0LD5GdUCqCtVqZOp4c
	 fptXBFEdDdnJpjowy/OoJ3+cxlnJ5P1rUvORDgvPuQCMxpAM92suhCO7VNxoE6Ck68
	 FSmeQFakKRGK2bQx5fsKuLK2HkUflkK7YQYLYJIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent YUE <vince@palmit.com.au>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0087/1005] scsi: mpt3sas: Register devices during SANITIZE
Date: Wed, 25 Nov 2026 15:23:45 +0100
Message-ID: <20261125143823.778804231@linuxfoundation.org>
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

From: Vincent YUE <vince@palmit.com.au>

[ Upstream commit d58e6d962e5b59297be24d908f41af93f20ec11f ]

A SAS disk being sanitized responds to TEST UNIT READY with NOT READY, ASC
0x04, ASCQ 0x1b. mpt3sas discovery maps this sense to DEVICE_START_UNIT and
issues START UNIT repeatedly. The drive stays NOT READY until the sanitize
operation completes, causing discovery to exhaust its retry budget and
decline SCSI device registration.

Allow registration only for the SANITIZE IN PROGRESS sense, so sd/sg can
expose the target while retaining its actual NOT READY state.  All other
sense dispositions are unchanged.

On an LSI SAS3008 with an HGST HUH728080AL4200, unpatched Linux 7.2.11
retried discovery 145 times without registering the device.  Linux 6.18.55
registered the same sanitizing drive. With the equivalent 7.2.11 fix the
disk registered as /dev/sda (0 B) and /dev/sg0 while TEST UNIT READY still
reported 02/04/1b and 47.32% SANITIZE progress. Another SAS drive continued
to enumerate.

This updated variant uses the named 0x041b sense constant introduced in
newer kernels. It passed static review on the current SCSI for-next branch
but has not been independently boot-tested there.

Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and readiness handling for slow devices")
Assisted-by: LLM
Signed-off-by: Vincent YUE <vince@palmit.com.au>
Link: https://patch.msgid.link/20261020210856.42835-1-vince@palmit.com.au
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 085d4672db854..a77bbc3d2b666 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7700,7 +7700,9 @@ _scsih_determine_disposition(struct MPT3SAS_ADAPTER *ioc,
 				u16 scode = scsi_sense_code(sense_info.asc,
 							    sense_info.ascq);
 
-				if (scode ==
+				if (scode == LU_NOT_READY_SANITIZE_IN_PROGRESS)
+					rc = DEVICE_READY;
+				else if (scode ==
 				    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED ||
 				    scode ==
 				    LU_NOT_ACCESSIBLE_TARGET_PORT_IN_STANDBY_STATE ||
-- 
2.53.0



