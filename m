Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061429;
	b=zOE9Lp9HAoIS+pKS+nj2LgaR0VORkxdN5o2VJmaN+f0tn6rjVjASD6CUpr/D3ojuWNhN
	 LHZ4oDhy6/OmW7FtyHJuVI8UqL8/PdoNRbY3ypeYpeOH/LAG0SFdV05W6iX71Q3kKDklQ
	 aCqQ/V84r+Gtp+I59MWFrr3hhCOk34tmP9+5UBp1DeprkVsrG28Wi1wqWu3zzHzI8/lGR
	 Hi0Zt6GjxeUlBtz3U8FlNOsg9qNzJIYYCCfAEPsaiP1sI5TUMWCmupmirfw3gtmNtza88
	 328RvXXFM7TkH67nNJhvRSjfARgUVwLWBdGf0Y0dy0fe4w/HsH8ztEHqZt+C9Idt0WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/jSIChhaAd2ZBF5CK/WuZZIB4BiCPi5jhDSlhTjVKro=;
	b=EFAijqbo40yp7LWMx5qSJaPyPzg2atAX5NTuUGJOsnQiX+7rcRXKnLwDdXhNLjqmEk6y
	 TkSxGOkG2hkngMDfTnPHz12YgRHOlFyocOKwYLW9EB2apK6UzBRSJfPRDGo2swuxzJXg7
	 MpHl4d8N5MWqXG5MkFP8OptJiwTqnjoNBZE4/wx8MBmUr+cquHV+Whn9N6i9Aql4FlJA2
	 ns1X74j9gu4e60AJt+BcjI38yOkv03W5bCY/bCer9tpAQubfO9j/bpxC6CCU2C/h/S7lz
	 C12IMZk7VLjWa5i0YcP4wpUBu+PKeYa9NFA8rb7Tez2xetWbXfOf7/svphQ3IRPQALg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhHGnOSr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A0606A320;
	Thu, 19 Nov 2026 04:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yhHGnOSr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BC91F000C4;
	Thu, 19 Nov 2026 04:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061429;
	bh=/jSIChhaAd2ZBF5CK/WuZZIB4BiCPi5jhDSlhTjVKro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhHGnOSrhrNvuBJWptc6uuaj3cIG6LFH8ftLtsG3y3TG4s/ov2LPosYyk+Mko3p+w
	 OuR2caR/Oj3Nk+8G6f3XmYvdjc3hwzKCAmGfASl8GES4CaUcIJORri6Mv8AlhmHYrz
	 tdRBF5JN4F8MbVhRUmGXWYUAEk6mrF7Xt+qJ6Emo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1547/1848] x86/PVH: dont truncate initrd address/size
Date: Wed, 18 Nov 2026 15:59:45 +0100
Message-ID: <20261118150024.367243104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 9ac7457f52a3c..1fd50f69dacae 100644
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



