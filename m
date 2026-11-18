Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041137;
	b=wja0u1xvT1HS5AESj6qr63sB17whBWPTX0zVmhLi2Y8ncQgOxbNX8W4ow0pIYftwyaxN
	 mpoQ0ViIGkKbI0/rsewBALBwgQTCszPTsAixR+ZEjtsUWwuXKu31m1Eu+9/zBdMSu2X70
	 W2jt+3yNrGBNnoNL6e4GqDhie/XLrQyjWV2Y8DfaFbl7/LuM8A0RgoW62nIM5xqjoXW2/
	 2pAVD9O4xikX7C0SQBDNVzQj8jw7l/koZ8/vDstHg2vZaYGx7ZKaWI8vpDTnaWeai9AVt
	 d4novU7WUhhbU9fg2GzFywd2NmIYidZKSfuQKdpBLkkJqnmR7+d7ZWoKfjfKE2/ODKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NXVY0bgww/ZG0sSxI8FzKb29uzbaONvNgirwIfhqd4s=;
	b=KIGuDvmyX5FRz7kHZT9opbSXKl7l4HIabHhOfrybuxpaNllPSvrMtdR7J1yqzb5bTjs/
	 M8+H5W2NpyHgkgH4F7KsfCaAW2F8joJBmnlF9J7gAGoDknZvqzlMbH+rjtNmetxEO16u6
	 e1rbp8/hthOAWB5E4fTDjeKfrfWUmDDOt4eSbsVcEpb5QYOSVPQFeOTH8H3UM6UGF/rBe
	 eLWQUVseKWdajw/Ya+p6qwudnImMLf4s/KUmq5E0F43QIb2UpgzpIqtbqpB+eDinNeZDC
	 AKwi7TP5HkOMfyugJAQgZ/4h2z7Mc7h6pe90zqsgAmAalesfODuSq9FubFC2EnMbLEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vebXMwVt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2CD606A32A;
	Wed, 18 Nov 2026 22:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vebXMwVt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA501F000C4;
	Wed, 18 Nov 2026 22:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041137;
	bh=NXVY0bgww/ZG0sSxI8FzKb29uzbaONvNgirwIfhqd4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vebXMwVtyhl0uYuoNZMnCsxqvmxs0rVq9fwdqzyIPxmAILrBDHoZYVO+DgYhplM/K
	 ygjN6pmUYs4i+4EgEEZMa+z5rNLrVRVYgYqPJP1Ft2eBFrsUrF7Ykk7GLdH55meIyl
	 twqphM73iUGoHOEU22v5UpN+v0gIZMew9kmEBujs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2705/3318] x86/PVH: dont truncate initrd address/size
Date: Wed, 18 Nov 2026 15:55:27 +0100
Message-ID: <20261118150442.052352853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit fcc43d1d6bf5fbd41e1e308b17187f9b759df56a ]

Consuming merely the lower halves of the provided values isn't very
useful. (While generally loaders try to place it below 4G, especially
when it's huge it may not fit there.)

Fixes: 7243b93345f7 ("xen/pvh: Bootstrap PVH guest")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

Message-ID: <9698d810-6664-4a9d-a847-18ad124261e0@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/pvh/enlighten.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index 00a92cb2c8147..b48e41e8186c6 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -82,7 +82,9 @@ static void __init init_pvh_bootparams(bool xen_guest)
 		struct hvm_modlist_entry *modaddr =
 			__va(pvh_start_info.modlist_paddr);
 		pvh_bootparams.hdr.ramdisk_image = modaddr->paddr;
+		pvh_bootparams.ext_ramdisk_image = modaddr->paddr >> 32;
 		pvh_bootparams.hdr.ramdisk_size = modaddr->size;
+		pvh_bootparams.ext_ramdisk_size = modaddr->size >> 32;
 	}
 
 	/*
-- 
2.53.0



