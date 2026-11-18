Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019290;
	b=4kgTbi6OZj+IlpMs5k1GePZWcH9HH876rIXDYNErt7CUkj8HGWxcvjahMNf076K9yqgT
	 kc2qzmZ6/avJsHNZDFSxB9SRT+LjaH90Mrj/QnS5gE14rZKNL1YqW1SHaXwuShihSxVkv
	 bB/jtRlcFvaJAAylA7uFbN7VlXwTjiXkXllQrHO4ybZmMx9y5c0OJsCoo+tolN2JQPpXW
	 X0KOQeR6YtYjiqsKBKE+lEjIsFdLxskzrr+DOhk88LzEj6EnLSzATkay1ZuPxrFMSd8En
	 tEjd83hf4tII0bYaCUDaKejaD0JUAPl5gDVXwLeCgIr/p4rAJAdhkiiOjmJ8YFMIDiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nWYeMINLlAKuOc1Nv045ByR0Rfp8MFzkKge8LwlnNVc=;
	b=DNlRgrJJhVXgFPF9Ju2T020TNtNJR452Ha48puVbNB3mYCO7Kd5rp1d917TRdmb1ojMW
	 JvCUKAUeQcT9bnWzPu1mN1oEv2L0bGVeitW2jcdxg3CSMmxBAs/gLIjPuP5hCDS7wfPO3
	 U5meHeQVigw9Oi1ALxl/vRamtdnZhhwT+F/AZdepiPOpNBvTzaoafpq+Hc6/itUHmV7Cg
	 ZV+kio3PHRHa3GzV9R9eo6RI/LEehC4Pco7ToVL6/237XVoJwwDlgJLQeMeAFSxlVf1v9
	 hssucHiK6MXM5pXSwwZywjuiZj2jAVxCtxCUkGFxJzzKBY9RybejUcZmmF/gKQn6LxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4XSMc+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23160A2614;
	Wed, 18 Nov 2026 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4XSMc+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC73D1F000C4;
	Wed, 18 Nov 2026 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019290;
	bh=nWYeMINLlAKuOc1Nv045ByR0Rfp8MFzkKge8LwlnNVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4XSMc+Xg0kAxcEOuWPT7pWYGqJATJV3Cs8CPfsIGsHYhZenlM+PcZPteaqSXQ9Qq
	 8bgGSJQrN8CxySd7LeQyX1KmymTGOsJSR0vhwQT+bJSmJlXPrCt75cx3BAiRrlEnHY
	 X96sYFtf384BJHGDS/GQGt4FzwYLzhxlDWOuPMr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1544/2651] x86/PVH: dont truncate initrd address/size
Date: Wed, 18 Nov 2026 15:46:24 +0100
Message-ID: <20261118150343.551856670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index cb442cbd9d828..88632c661430f 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -79,7 +79,9 @@ static void __init init_pvh_bootparams(bool xen_guest)
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



