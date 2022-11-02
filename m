Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B7B7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B33FC433D6;
	Wed,  2 Nov 2022 02:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357016;
	bh=36vMXQiLp+DMXPRyybQZWrIANX2m/HBElshj2DV0f54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtMXb8/Qg58oxAxPo/219fZGxOkMJ4MEa81phs6FXwm5t1jdrepLPHfkhyGHyBAy6
	 9n6t7amC4kPwyCpxpvIcyvSnlveSLUSq/xKOiXXCNy9260CdKINL+UanP4efBl4/8N
	 CknkQ25EXAcc9RgOwWxi5P6lgCCuwnd6z5OAlG6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.0 099/240] s390/boot: add secure boot trailer
Date: Wed,  2 Nov 2022 03:31:14 +0100
Message-Id: <20221102022113.632502953@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit aa127a069ef312aca02b730d5137e1778d0c3ba7 upstream.

This patch enhances the kernel image adding a trailer as required for
secure boot by future firmware versions.

Cc: <stable@vger.kernel.org> # 5.2+
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/vmlinux.lds.S |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/s390/boot/vmlinux.lds.S
+++ b/arch/s390/boot/vmlinux.lds.S
@@ -102,8 +102,17 @@ SECTIONS
 		_compressed_start = .;
 		*(.vmlinux.bin.compressed)
 		_compressed_end = .;
-		FILL(0xff);
-		. = ALIGN(4096);
+	}
+
+#define SB_TRAILER_SIZE 32
+	/* Trailer needed for Secure Boot */
+	. += SB_TRAILER_SIZE; /* make sure .sb.trailer does not overwrite the previous section */
+	. = ALIGN(4096) - SB_TRAILER_SIZE;
+	.sb.trailer : {
+		QUAD(0)
+		QUAD(0)
+		QUAD(0)
+		QUAD(0x000000207a49504c)
 	}
 	_end = .;
 


