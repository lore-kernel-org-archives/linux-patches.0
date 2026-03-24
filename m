Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997293D6CAB
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774359643; cv=none; b=c1vqed0VkmuT8yB9RaowWqQN3GeD0//7GLJX3E/VB6EXc83PoE2mBmebPmUyFx8lyNBlkYHsIatCO+8IOFYPT1wTk2UG6tcueI4Qx8GyJAGBCX2BBV/brKQ/V9gDun47K8vcmAaVEofiWDyGVMhheuJUuRaJ2czxzVipGHdsNDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774359643; c=relaxed/simple;
	bh=DB8sj3O8zIEtdMglYDNzhkPxuBV4sfXtfqTz2jAOpAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5hAN7rtQM8ZStJi4RSCsyivsQTNZQcHn1nBNGbgMdbHt0GAzfn/5PJwYX48TdmT2j3BRQr5tcwDy+bCG2Z6/TuYA3HRPX1ciZooiG/T1+jp9ztjUJ5amnl1SeTy59s3spDc7ZxmucVYKQ9mDr22OnZuK/fvp60MZvuMSKX7BFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2TI68cai; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vdNbABGF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2TI68cai; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vdNbABGF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2TI68cai";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vdNbABGF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2TI68cai";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vdNbABGF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 058235BD26;
	Tue, 24 Mar 2026 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774359640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HEowlndxnuwsn9HVqNtXyXIZr2cj2jqZ1HgraebDcfs=;
	b=2TI68cai5rioLLy0ZZ330ZUge44UFBQsHbCkZl7YwCrfRT66dc6q1zojWFsinWKnoErymc
	LvXTq7E7EeunhRBMjVcwVbOEHhpHt0pCdfFFsWMTh8AOYURPp9ztWQpir2+VAotMO1hdNy
	GNscK9D6P/uIGJdrSoDgWpZmkvb96qc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774359640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HEowlndxnuwsn9HVqNtXyXIZr2cj2jqZ1HgraebDcfs=;
	b=vdNbABGFHKDCaDxTQMMeApArn1cqYrZ1T4FBVLDCDnW6wmuUCuW5giIBhkXKriBLqY0Lqm
	rwJS20YMV8ZlLgBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774359640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HEowlndxnuwsn9HVqNtXyXIZr2cj2jqZ1HgraebDcfs=;
	b=2TI68cai5rioLLy0ZZ330ZUge44UFBQsHbCkZl7YwCrfRT66dc6q1zojWFsinWKnoErymc
	LvXTq7E7EeunhRBMjVcwVbOEHhpHt0pCdfFFsWMTh8AOYURPp9ztWQpir2+VAotMO1hdNy
	GNscK9D6P/uIGJdrSoDgWpZmkvb96qc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774359640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HEowlndxnuwsn9HVqNtXyXIZr2cj2jqZ1HgraebDcfs=;
	b=vdNbABGFHKDCaDxTQMMeApArn1cqYrZ1T4FBVLDCDnW6wmuUCuW5giIBhkXKriBLqY0Lqm
	rwJS20YMV8ZlLgBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA8B643E77;
	Tue, 24 Mar 2026 13:40:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jhQ4OVeUwmksNgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 13:40:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AA894A0B32; Tue, 24 Mar 2026 14:40:31 +0100 (CET)
Date: Tue, 24 Mar 2026 14:40:31 +0100
From: Jan Kara <jack@suse.cz>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>, 
	Yongjian Sun <sunyongjian1@huawei.com>, Matthew Wilcox <willy@infradead.org>, 
	Gou Hao <gouhao@uniontech.com>, Theodore Ts'o <tytso@mit.edu>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Zhang Yi <yi.zhang@huawei.com>, Baokun Li <libaokun1@huawei.com>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <mhqesgj3u7dr33zit6iwjhykw2zpuallru4qvoloyyqzdqgvki@bpwwmihh357r>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324073447.GA5062@francesco-nb>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	MIME_TRACE(0.00)[0:+];
	R_RATELIMIT(0.00)[to_ip_from(RLcbqemsx4jma477jikb7d9ob4)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linuxfoundation.org,suse.cz,redhat.com,huawei.com,infradead.org,uniontech.com,mit.edu,huaweicloud.com,vger.kernel.org,lists.linux.dev,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,nabladev.com,nvidia.com,gmail.com,gmx.de,microsoft.com,achill.org,sladewatkins.com];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

Hi!

On Tue 24-03-26 08:34:47, Francesco Dolcini wrote:
> On Mon, Mar 23, 2026 at 02:39:42PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.167 release.
> > There are 481 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> > Anything received after that time might be too late.
> 
> Not ok
> 
> I have an ext4 Oops on arm
> 
> [   27.908560] 8<--- cut here ---
> [   27.911697] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [   27.919880] [00000000] *pgd=00000000
> [   27.923482] Internal error: Oops: 5 [#1] SMP ARM
> [   27.928117] Modules linked in: 8021q cfg80211 imx_sdma coda_vpu v4l2_jpeg imx_vdoa dw_hdmi_ahb_audio fuse
> [   27.937784] CPU: 1 PID: 736 Comm: tar Not tainted 6.1.167-rc1-6.8.6-devel+git.67c872a868ac #1
> [   27.946342] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [   27.952889] PC is at ext4_mb_load_buddy_gfp+0xac/0x438

Can you run this through "addr2line -i" to get exact position in that big
function? Because from a quick look it doesn't ring a bell...

								Honza

> [   27.958083] LR is at 0xe0f39b18
> [   27.961248] pc : [<c035bc54>]    lr : [<e0f39b18>]    psr: 000f0013
> [   27.967536] sp : e0f39b60  ip : 00000000  fp : c43046f8
> [   27.972781] r10: 00000001  r9 : 00000c40  r8 : 00000016
> [   27.978025] r7 : 00000016  r6 : c2b24000  r5 : e0f39bcc  r4 : 00000000
> [   27.984574] r3 : d21b9611  r2 : d21b9611  r1 : c4277e40  r0 : 00000000
> [   27.991123] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [   27.998287] Control: 10c5387d  Table: 131c804a  DAC: 00000051
> [   28.004050] Register r0 information: NULL pointer
> [   28.008787] Register r1 information: slab radix_tree_node start c4277e40 pointer offset 0
> [   28.017024] Register r2 information: 0-page vmalloc region starting at 0xd0000000 allocated at iotable_init+0x0/0xf4
> [   28.027619] Register r3 information: 0-page vmalloc region starting at 0xd0000000 allocated at iotable_init+0x0/0xf4
> [   28.038199] Register r4 information: NULL pointer
> [   28.042930] Register r5 information: 2-page vmalloc region starting at 0xe0f38000 allocated at kernel_clone+0x88/0x338
> [   28.053693] Register r6 information: slab kmalloc-1k start c2b24000 pointer offset 0 size 1024
> [   28.062369] Register r7 information: non-paged memory
> [   28.067449] Register r8 information: non-paged memory
> [   28.072527] Register r9 information: non-paged memory
> [   28.077605] Register r10 information: non-paged memory
> [   28.082771] Register r11 information: slab ext4_inode_cache start c4304620 pointer offset 216 size 60
> [   28.092056] Register r12 information: NULL pointer
> [   28.096875] Process tar (pid: 736, stack limit = 0x116a0825)
> [   28.102562] Stack: (0xe0f39b60 to 0xe0f3a000)
> [   28.106955] 9b60: e0f39b5c 00000000 c0c1b414 c2916000 c2b24000 c42e55d8 c2b24000 c29162a8
> [   28.115162] 9b80: 00000048 c4589000 0000000b c035f804 00000001 00000001 00000001 c2b24000
> [   28.123368] 9ba0: c2916000 0000001d 00000010 00000000 00000009 00000024 00000000 00000000
> [   28.131573] 9bc0: c2b92300 00000001 00000000 00000000 e0f39d30 00000000 c2b92300 c42e55d8
> [   28.139778] 9be0: c2b24000 0000000c 0000000b d21b9611 00000000 c4589000 c2b24000 e0f39d30
> [   28.147983] 9c00: 00000001 c2916000 00000000 c42fbf60 00000001 c03628c0 00000001 00000000
> [   28.156188] 9c20: e0f39d14 c2b92300 00000001 00000000 00000029 00000000 00000000 c03328b4
> [   28.164393] 9c40: 00000000 00000000 c4886a60 c033be7c 00000000 c0294008 00000000 00000000
> [   28.172597] 9c60: c48867d0 d21b9611 c2b92300 00000001 00000001 c2916000 00000000 00000000
> [   28.180802] 9c80: 00000000 c48868a8 e0f39e10 c0336970 e0f39d24 47ffffff c2b24000 00000000
> [   28.189007] 9ca0: c48868a8 00000000 e0f39d88 c0330844 00000000 00000001 c2b92300 c42fbf60
> [   28.197212] 9cc0: e0f39d88 ffffffff 00000000 ffffffff c308da80 00000000 00000001 c308da98
> [   28.205416] 9ce0: 00000000 c03362f4 ffffffff ffffffff 00000008 00000010 00000000 cf358340
> [   28.213620] 9d00: c42fbf60 00000000 c0c1b2c8 00000000 c308da80 00000000 00000000 c4540001
> [   28.221825] 9d20: 00000000 c0395154 c2b92300 000009dd c48868a8 00000001 00000000 00000000
> [   28.230029] 9d40: 00000000 c034c0c0 00000000 00000000 00000000 00000000 00000000 00000000
> [   28.238234] 9d60: 00000000 00000000 c4886a60 d21b9611 00000020 e0f39e10 c48868a8 00000000
> [   28.246438] 9d80: 00000001 c42fbf60 c2b92300 00001000 00000000 c034ccdc 00000000 00000000
> [   28.254642] 9da0: 00000000 00000000 c42fbf60 c4886890 00000000 00000000 c48868a8 00000000
> [   28.262847] 9dc0: c4886a60 00000000 ffffffff e0f39e70 ffffffff 47ffffff 00000000 d21b9611
> [   28.271052] 9de0: c2b92300 c48868a8 c48868a8 c42fbf60 c2b92300 00000000 00000001 00001000
> [   28.279256] 9e00: 00000000 c034dc98 c48868a8 c038d7f4 00000000 00000000 00000000 00000001
> [   28.287461] 9e20: 00000000 cf358300 00000000 d21b9611 c48868f0 c48868a8 00000000 c42fbf60
> [   28.295666] 9e40: c2b92300 e0f39ec0 00000001 c034ded0 c48868a8 00000000 c42fbf60 c0367fec
> [   28.303871] 9e60: 0000001d 000041ed 00000000 c42ffcd8 00000000 00000000 00000000 00000001
> [   28.312076] 9e80: 00000000 c48868a8 69c15bf6 d21b9611 119d9a05 c48868a8 c2b24000 00000000
> [   28.320281] 9ea0: 00000000 c42fbf60 c2b92300 c036e134 00000000 c036b544 00000000 c43043e8
> [   28.328486] 9ec0: 00000000 d21b9611 0000000c c48868a8 c48868a8 c42fbf60 c43043e8 c0c1bc80
> [   28.336690] 9ee0: 000041ed c2b92300 c120d3e8 c036e410 c42ffcd8 00000000 00000000 00000000
> [   28.344895] 9f00: 00000004 00000bfa 00000027 c02a9b20 00000000 00000027 c42ffcd8 c42ffcc0
> [   28.353100] 9f20: 00000000 d21b9611 00000002 c43043e8 c036e298 c120d3e8 c42ffcc0 00000000
> [   28.361305] 9f40: 00000002 c2b92300 be83b824 c02ab1a0 c34dc010 d21b9611 01db0478 c34dc000
> [   28.369510] 9f60: c42ffcc0 c34dc000 ffffff9c 000041ed 00000000 c02b0268 be83b824 c20c6910
> [   28.377715] 9f80: c42e2a18 d21b9611 01db0478 01db01f8 00000000 00000027 c01002e8 c2b92300
> [   28.385920] 9fa0: 00000027 c0100080 01db0478 01db01f8 01db0478 000041ed 00000020 00004000
> [   28.394124] 9fc0: 01db0478 01db01f8 00000000 00000027 00000000 00000007 01db01f8 be83b824
> [   28.402330] 9fe0: 00545dbc be83b754 004f9b0b b6e5ff98 600f0030 01db0478 00000000 00000000
> [   28.410535]  ext4_mb_load_buddy_gfp from ext4_mb_regular_allocator+0x318/0xee0
> [   28.417826]  ext4_mb_regular_allocator from ext4_mb_new_blocks+0x724/0x1000
> [   28.424847]  ext4_mb_new_blocks from ext4_ext_map_blocks+0x7d8/0x1600
> [   28.431351]  ext4_ext_map_blocks from ext4_map_blocks+0x21c/0x604
> [   28.437492]  ext4_map_blocks from ext4_getblk+0x68/0x298
> [   28.442844]  ext4_getblk from ext4_bread+0x8/0xa0
> [   28.447587]  ext4_bread from ext4_append+0x98/0x1b4
> [   28.452514]  ext4_append from ext4_init_new_dir+0x7c/0x1e0
> [   28.458061]  ext4_init_new_dir from ext4_mkdir+0x178/0x384
> [   28.463608]  ext4_mkdir from vfs_mkdir+0xcc/0x168
> [   28.468364]  vfs_mkdir from do_mkdirat+0x80/0x104
> [   28.473107]  do_mkdirat from ret_fast_syscall+0x0/0x54
> [   28.478285] Exception stack(0xe0f39fa8 to 0xe0f39ff0)
> [   28.483367] 9fa0:                   01db0478 01db01f8 01db0478 000041ed 00000020 00004000
> [   28.491573] 9fc0: 01db0478 01db01f8 00000000 00000027 00000000 00000007 01db01f8 be83b824
> [   28.499775] 9fe0: 00545dbc be83b754 004f9b0b b6e5ff98
> [   28.504856] Code: ebfbad72 e3700a01 e1a04000 8a00005d (e5903000)
> [   28.511102] ---[ end trace 0000000000000000 ]---
> 
> 
> The bug is not systematic, and I do not see myself having the time to
> bisect it in the next couple of days (it was reproduced by our CI / Lava
> infrastructure).
> 
> I have added some of the ext4 folks to this thread, in case they know
> how to help.
> 
> Francesco
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
