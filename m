Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DDF1DE3D6;
	Wed, 19 Feb 2025 08:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954465; cv=none; b=P7UHG3vs3W3PwaL++KkqWl5mKk1aMdXS0WDbH8P12nLvJYCMP5YjA75ruKN+tf+tktb5w7G5hiwpMI2UaHGlHeIHWRcPNHlmtBLGv6m/Wis8N4L5F5VJ0vv0hYg+boanGff/PxL5RYC/KWJeCoYCpTrgS9SUEJ4+IrezLIbC9UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954465; c=relaxed/simple;
	bh=8zfJCjb7xA5SUgYMCTBSS+asuO2jj8lvm6Ey9v85ZTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbsG/oIkeq5sBxmn85DiDCuFvt0n2jj5/45iaRtY4hVa85FHmJxlIatTsZP0eKLf99VIcTQE50q7JglMBsn+m27VuisZwGoVmzPmekkBGT3h6hc3sncf2jvaYjkwZDOXhD7UrFX+t9t58kElY9spKbWRP1nvoHqlN+9yyzNi9Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHrxvCUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHrxvCUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0A1C4CED1;
	Wed, 19 Feb 2025 08:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954464;
	bh=8zfJCjb7xA5SUgYMCTBSS+asuO2jj8lvm6Ey9v85ZTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHrxvCUsrEneDuHtL4/L4aH+NdZjn7xBA4H+MqJXVtdhmdcKVB3992Q9C1L+DrSnC
	 K+SJ7uhpuXyRCpKiTZ3adekZ0g8tE3cwx21/FS2mz1MExS930C/9Z10tH3UhgPeBYw
	 ZZ7bEwgjDtyvpO+5Ceo5TnuUR6zaQOGz7quo1eMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruowen Qin <ruqin@redhat.com>,
	Jinghao Jia <jinghao7@illinois.edu>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 206/274] samples/hid: remove unnecessary -I flags from libbpf EXTRA_CFLAGS
Date: Wed, 19 Feb 2025 09:27:40 +0100
Message-ID: <20250219082617.636980336@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinghao Jia <jinghao7@illinois.edu>

[ Upstream commit 1739cafdb8decad538410b05a4640055408826de ]

Commit 5a6ea7022ff4 ("samples/bpf: Remove unnecessary -I flags from
libbpf EXTRA_CFLAGS") fixed the build error caused by redundant include
path for samples/bpf, but not samples/hid.

Apply the same fix on samples/hid as well.

Fixes: 13b25489b6f8 ("kbuild: change working directory to external module directory with M=")
Tested-by: Ruowen Qin <ruqin@redhat.com>
Signed-off-by: Jinghao Jia <jinghao7@illinois.edu>
Link: https://patch.msgid.link/20250203085506.220297-2-jinghao7@illinois.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/hid/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/samples/hid/Makefile b/samples/hid/Makefile
index 8ea59e9631a33..69159c81d0457 100644
--- a/samples/hid/Makefile
+++ b/samples/hid/Makefile
@@ -40,16 +40,17 @@ BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
 endif
 endif
 
-TPROGS_CFLAGS += -Wall -O2
-TPROGS_CFLAGS += -Wmissing-prototypes
-TPROGS_CFLAGS += -Wstrict-prototypes
+COMMON_CFLAGS += -Wall -O2
+COMMON_CFLAGS += -Wmissing-prototypes
+COMMON_CFLAGS += -Wstrict-prototypes
 
+TPROGS_CFLAGS += $(COMMON_CFLAGS)
 TPROGS_CFLAGS += -I$(objtree)/usr/include
 TPROGS_CFLAGS += -I$(LIBBPF_INCLUDE)
 TPROGS_CFLAGS += -I$(srctree)/tools/include
 
 ifdef SYSROOT
-TPROGS_CFLAGS += --sysroot=$(SYSROOT)
+COMMON_CFLAGS += --sysroot=$(SYSROOT)
 TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
 endif
 
@@ -112,7 +113,7 @@ clean:
 
 $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OUTPUT)
 # Fix up variables inherited from Kbuild that tools/ build system won't like
-	$(MAKE) -C $(LIBBPF_SRC) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
+	$(MAKE) -C $(LIBBPF_SRC) RM='rm -rf' EXTRA_CFLAGS="$(COMMON_CFLAGS)" \
 		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(HID_SAMPLES_PATH)/../../ \
 		O= OUTPUT=$(LIBBPF_OUTPUT)/ DESTDIR=$(LIBBPF_DESTDIR) prefix= \
 		$@ install_headers
-- 
2.39.5



