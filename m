Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ADA4E1C6E
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 20:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591910; cv=none; b=cEV4zx6tYRh0rIQ5IllRky6blsUnrxe7P+fF27yl8ilKcPuTy9OzrpQZrkhq0CzHlatlcvcNoVe8E8x8s4vKS3k7XoVl7fKgRUAOCIyVAdkcH4qz+zodjYl5jt6YIY8rOOLikxEm1bWnN2zDnNwtdT8qbBB4q+PGpNExvUuV6QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591910; c=relaxed/simple;
	bh=TCWY2BqZ1qzi2wcRuFONl0b53QLimSTyupwbYjE4xwI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=F+6toI/mnTz3PYIwKjEZ2fBj+NTZSfvOhQsihTP0k5bm6YK9DFT5Ca/yc1A5drLUOVx4yGq2FAjnXASDkR6gvfyTCaOFAq9Nng3LwtofohCly4olfGLpb9tjSAnkXHjgMw2HvSoj4kRqGmFVtCxuRTQ/FunKmFR4PnF6CYrhV9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6b36cf0d9d3so107094eaf.1
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 13:51:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789591904; x=1790196704;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=p7jostc6F+Tr/4gi2k1tEb3SXjkRDvQsC2W4kcZOoic=;
        b=Cy6CmQRxs0xkX7pxW1iqpovpchsKAj1VGTDB8q7K0XltxWWGNj8HH5g7bmPeOklkSn
         ZttM/5KOv6MzBx/Vvd/jKy3l8UQ/a/wiVHj+BKIXjludagX0xciSoDAH49bJXA5L7WlW
         9Ojt4vprZxjYc4auIAAmCIoT1ME3etE7yU+f9zWDnZWZVwjf+iyFlwjJ1KYDD0Yxe040
         nDa0u+VbCj1hJAMJ4BdS84EI+Jgn91p3sPF3XWGRNrN34HFM67ynN9Y+osnVYDouAOIY
         vQi2juaOWo+5FwoLpkYkzuw1NV3VHW6MRAArZWeMiK4duD+IiFAa4Knd+5oEAogRO6b6
         Jb2Q==
X-Forwarded-Encrypted: i=1; AKwUvBy7cAkKQIYgW6SZJCmI++L3pL49IjUx8+7AYovj217Cf0p2w4kVHIA+oI4QB98l50lswHzGMQII@lists.linux.dev
X-Gm-Message-State: AFuF++ki3p0+HjzZE/d6L7exOKFVdODzerU1lRRNHouo3Xf9P8WBrMVR
	8wCufB0fUEppJ462acZeQ3DvpthA8RVnJEuccDpWIW5g1Dc6H361G35e0BUwQg/FxVTbXQNtaDl
	1ZqxgTuZa/WORETfKxnIIOn+64KIMu2ODA7jAlxcqlTQCccfNYdVyT935Dh4=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f02e:b0:6bd:b31a:4b1f with SMTP id
 006d021491bc7-6c7d48f017amr6929574eaf.29.1789591904124; Wed, 16 Sep 2026
 13:51:44 -0700 (PDT)
Date: Wed, 16 Sep 2026 13:51:44 -0700
In-Reply-To: <6a74a7e9.01d0871a.3a0d52.0023.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aab0160.e91c2013.3bdb06.0005.GAE@google.com>
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in trace_event_raw_event_udc_log_req
From: syzbot <syzbot+de553c19cb054f174a35@syzkaller.appspotmail.com>
To: andrzej.p@samsung.com, balbi@ti.com, bigeasy@linutronix.de, 
	frank.li@nxp.com, gregkh@linuxfoundation.org, hhhuuu@google.com, 
	jeffinphilip14@gmail.com, kai.aizen.dev@gmail.com, kees@kernel.org, 
	laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org, 
	linux-usb@vger.kernel.org, patches@lists.linux.dev, 
	stable-commits@vger.kernel.org, stable@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, xu.yang_2@nxp.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    9b87fdc9af2f Merge tag 'sched_ext-for-7.3-rc3-fixes' of gi..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=10073925580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5c3949d762a91f
dashboard link: https://syzkaller.appspot.com/bug?extid=de553c19cb054f174a35
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14073925580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de553c19cb054f174a35@syzkaller.appspotmail.com

RBP: 00007ffd24c2deb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000b
R13: 64755f796d6d7564 R14: 00007f7ea170aa41 R15: 0000000000000000
 </TASK>
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 UID: 0 PID: 6018 Comm: syz-executor177 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:do_trace_event_raw_event_udc_log_req drivers/usb/gadget/udc/trace.h:223 [inline]
RIP: 0010:trace_event_raw_event_udc_log_req+0x207/0x6c0 drivers/usb/gadget/udc/trace.h:223
Code: e2 83 e2 07 38 d0 7f 08 84 c0 0f 85 7f 04 00 00 49 8d 7d 10 41 c6 04 24 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 4b 04 00 00 49 8d 7f 0c 41 8b
RSP: 0018:ffffc900055379e0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff8cda4a23 RDI: 0000000000000010
RBP: 1ffff92000aa6f3e R08: 0000000000000001 R09: ffffed1003ed2e25
R10: ffff88801f69712e R11: 0000000000000001 R12: ffff88801f69712f
R13: 0000000000000000 R14: ffffffff8cda4a20 R15: ffff88801f6970ec
FS:  000055558eb7d400(0000) GS:ffff8880d5c59000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d12b7cc300 CR3: 0000000036264000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __do_trace_usb_ep_alloc_request drivers/usb/gadget/udc/trace.h:264 [inline]
 trace_usb_ep_alloc_request drivers/usb/gadget/udc/trace.h:264 [inline]
 usb_ep_alloc_request+0x217/0x2e0 drivers/usb/gadget/udc/core.c:202
 gadget_bind+0xe7/0x660 drivers/usb/gadget/legacy/raw_gadget.c:294
 gadget_bind_driver+0x28c/0xbf0 drivers/usb/gadget/udc/core.c:1662
 call_driver_probe drivers/base/dd.c:628 [inline]
 really_probe+0x241/0xa60 drivers/base/dd.c:706
 __driver_probe_device+0x210/0x460 drivers/base/dd.c:868
 driver_probe_device+0x4a/0x140 drivers/base/dd.c:898
 __driver_attach+0x21f/0x5b0 drivers/base/dd.c:1292
 bus_for_each_dev+0x13e/0x1d0 drivers/base/bus.c:383
 bus_add_driver+0x305/0x5b0 drivers/base/bus.c:763
 driver_register+0x1e2/0x360 drivers/base/driver.c:174
 usb_gadget_register_driver_owner+0x132/0x210 drivers/usb/gadget/udc/core.c:1752
 raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:596 [inline]
 raw_ioctl+0x1a85/0x2b80 drivers/usb/gadget/legacy/raw_gadget.c:1307
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7ea16ae7bb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffd24c2de50 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f7ea16ae7bb
RDX: 0000000000000000 RSI: 0000000000005501 RDI: 0000000000000003
RBP: 00007ffd24c2deb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000b
R13: 64755f796d6d7564 R14: 00007f7ea170aa41 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:do_trace_event_raw_event_udc_log_req drivers/usb/gadget/udc/trace.h:223 [inline]
RIP: 0010:trace_event_raw_event_udc_log_req+0x207/0x6c0 drivers/usb/gadget/udc/trace.h:223
Code: e2 83 e2 07 38 d0 7f 08 84 c0 0f 85 7f 04 00 00 49 8d 7d 10 41 c6 04 24 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 4b 04 00 00 49 8d 7f 0c 41 8b
RSP: 0018:ffffc900055379e0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff8cda4a23 RDI: 0000000000000010
RBP: 1ffff92000aa6f3e R08: 0000000000000001 R09: ffffed1003ed2e25
R10: ffff88801f69712e R11: 0000000000000001 R12: ffff88801f69712f
R13: 0000000000000000 R14: ffffffff8cda4a20 R15: ffff88801f6970ec
FS:  000055558eb7d400(0000) GS:ffff8880d5c59000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d12b7cc300 CR3: 0000000036264000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	e2 83                	loop   0xffffff85
   2:	e2 07                	loop   0xb
   4:	38 d0                	cmp    %dl,%al
   6:	7f 08                	jg     0x10
   8:	84 c0                	test   %al,%al
   a:	0f 85 7f 04 00 00    	jne    0x48f
  10:	49 8d 7d 10          	lea    0x10(%r13),%rdi
  14:	41 c6 04 24 00       	movb   $0x0,(%r12)
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 4b 04 00 00    	jle    0x485
  3a:	49 8d 7f 0c          	lea    0xc(%r15),%rdi
  3e:	41                   	rex.B
  3f:	8b                   	.byte 0x8b


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
