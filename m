Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C617082D
	for <patches@lists.linux.dev>; Sat, 27 Jun 2026 00:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782520325; cv=none; b=fQDWD6yWPk6Ov9oFWNn745W5L1HapAjbTNtyl1XO43AfVVvsTDpHKZ6GQk9VoAJBmT/QQtFD2ic3q9AX2ay17J/6s2xNO2/e/1wzo8HRjffl+IqAW2LKBFQp5fBCJeN3XH67eteFl9zQ5FLN9YGznttIotx9KZ7wCgV6Oddmaig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782520325; c=relaxed/simple;
	bh=6LuQ8pggr4YAJuIBdtoIDwEpimEbXZr0dGgLbDqDObE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYSFFoQ8Hrh31u0NrfYD8fs5ZUOSK8Z2KctZqwwGzJW/f6BxCoIUqjNNKaO2Sg4ZxhmZinAxBSlCnb8p4mhyQ4lS/ywugKlrkhD9xqDcFS+YW3f53ckgruc/sE+Y/g/WdsQxa584AUp/c1z66R/G1Xc8STKbaaDzfQ8+rhVgxzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FK+gc1GE; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FK+gc1GE"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30ca1b4b278so1212959eec.0
        for <patches@lists.linux.dev>; Fri, 26 Jun 2026 17:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782520323; x=1783125123; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=df2IUvs0nGKzMIEEP7Xdb2jOl5F8u2fTp9lEESg3Lgc=;
        b=FK+gc1GEte72/LdaCeVJ83a2Zx2Xv1TKu9bDtVASF5u9mnWJruYEvA4/zlAj1EV6iQ
         M/pgtwhprVS73Rxt+B/dBJU7mZh+Pz9YobqISe/uEpBkFM8UeJOyKLv+vacz5cp2FJNH
         XO3qRSmcvNt9dV1fHBc2maGtxCmOd1v5SzlVEjujuItusSDd8hwOyBM+pP+VFtX8DMjr
         fuYNTT/VhrlYk0ilMPJd7dGAlS5lpFECseWQnryMvQRkAz5aPKywJ2c0b3qIA0CCP3qM
         PrXCFABTG4iXiJXEoZB3L3giWwAzJPCCcfwLY1NxB2XHaOY5zXPtpTXWEc1AyuQgygOe
         ZtNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782520323; x=1783125123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=df2IUvs0nGKzMIEEP7Xdb2jOl5F8u2fTp9lEESg3Lgc=;
        b=ZAVhzt4i+/XNvjRAt+H3ZZlphxTulj5Mu4oDMAfq/pe7qOYO9UxyKLJaJYqD5JmB5Q
         zLK4S8n/PVvUX2Rl3+6yzqbcFGt6E207tki7o2RsOPdzZloCYyrYm5ZNzl1NABJkSElN
         +GSEA9dqtiBEjJWnAthXabHJfPUNfy266r0Llb0sJ41wa0Mts+MdnBefF+kgI63Wlvg6
         DFEhQ5Bdg7b2dLBzdW48NCcZWY61MxY32YyF8eDm2Ex/dtTgugn0ZXZ9aL5VaqGUIN7y
         cuXxntOxDy8xsE3ncFcQJ3quu07o58Q0qzT0wxfR+ozjresOa4Yd3FsqRIHP8B/XEydP
         dnPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrkom6XWyX040L9aRLr428yoy/O81/uR3sYRtnt7elS4qC7Xu/hpiiAS2aSIioGpod8nHo+W3i+@lists.linux.dev
X-Gm-Message-State: AOJu0YxMbTUmNeFJ1cpP3phx0+/ypIMrV1oI9fFRuZ2rEnAujvum4pUf
	MQQHVoE1SxF6ir2W1q3rz8ntP+rSwDr+quXiXZweNdF7sgmjECl+5Qdw
X-Gm-Gg: AfdE7cnqL4dFMd53pjVf+puvcLmrM7/C4z2DSCZRBICvb28xkdCcgPAV/eFMNkuC6yc
	IgxTU2rRrrYYCOGJ1lBH+1UZhxkize/mtQj9KedVoFgIdXDOLhi01mPz0e0AsGq5r8sFRi9whML
	KaYJcnKGlyp/2ek5AGCulBvbzw6Rf9OJmv7NqVkIXdxcNy+ouddPmZtS8AfE/7juP4AtmVuJ1+k
	nkw4cyTxlu6EVGaBZbuCP3YvB8Xmf1PFfsybggER6xie/xdt9FdPgTDFSqj5lLGMyq/IT52/M9p
	HvTIb2jsB9cmpDiJrFGH8mFPu7hKoBbiE0aPGPTgjpmZp9luFZUtgYnIdCg9MMbiCyebhAl8xlo
	l91OTLWuLTWofpMI/HgN5z6tfLe2KHNmCQaH4MV93DlShNFcbS/738cZLW+8iK5nPNU6ZYm2L4e
	wiRUd/r2f2pjKRa4Lqfnwx+Y/g0U0hz6IPv8zACJV0zWgmlneii6+5RQ==
X-Received: by 2002:a05:7300:e6c4:b0:30c:6d2c:2aa7 with SMTP id 5a478bee46e88-30c84fa683fmr8704109eec.20.1782520322738;
        Fri, 26 Jun 2026 17:32:02 -0700 (PDT)
Received: from google.com ([2a00:79e0:2ebe:8:3348:4970:ea3e:6159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c8b1a80sm21396227eec.18.2026.06.26.17.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 17:32:02 -0700 (PDT)
Date: Fri, 26 Jun 2026 17:31:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Message-ID: <aj8WEfam__6fnNuM@google.com>
References: <20260625125613.243729608@linuxfoundation.org>
 <b7bd471b-e9da-4bfc-ad1d-24b378bd1e44@pobox.com>
 <aj7RmyBck8EkPn_s@google.com>
 <ab7df7bf-1b30-40c0-9463-a469abfa2bda@pobox.com>
 <aj7r1Eqt2SEnWsMZ@google.com>
 <626fc564-6f4b-430d-92f3-653981e3dcdd@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <626fc564-6f4b-430d-92f3-653981e3dcdd@pobox.com>

On Fri, Jun 26, 2026 at 03:23:12PM -0700, Barry K. Nathan wrote:
> On 6/26/26 2:17 PM, Dmitry Torokhov wrote:
> > On Fri, Jun 26, 2026 at 01:41:38PM -0700, Barry K. Nathan wrote:
> > > On 6/26/26 12:56 PM, Dmitry Torokhov wrote:
> > > > Hi Barry,
> > > > 
> > > > On Fri, Jun 26, 2026 at 10:56:21AM -0700, Barry K. Nathan wrote:
> > > > > (cc Dmitry Torokhov because this is related to two of your commits)
> > > > > 
> > > > > On 6/25/26 6:03 AM, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 7.1.2 release.
> > > > > > There are 21 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > > 
> > > > > > The whole patch series can be found in one patch at:
> > > > > > 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> > > > > > and the diffstat can be found below.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > > 
> > > > > Unfortunately, 7.1.2-rc1 breaks the Synaptics touchpad on my Lenovo
> > > > > ThinkPad T14 Gen 1 -- the pointer no longer moves when I touch the
> > > > > touchpad. Potentially relevant line from dmesg:
> > > > > 
> > > > > rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
> > > > > 
> > > > > > Dmitry Torokhov<dmitry.torokhov@gmail.com>
> > > > > >        Input: rmi4 - refactor register descriptor parsing
> > > > > > 
> > > > > > Dmitry Torokhov<dmitry.torokhov@gmail.com>
> > > > > >        Input: rmi4 - fix register descriptor address calculation
> > > > > > > Both of these patches seem bad in my testing. Either one, individually,
> > > > > causes the pointer to no longer move when I touch the touchpad. If I
> > > > > revert both of them, then my touchpad works again.
> > > > > 
> > > > > I have not yet tested 7.0.14-rc1 or 6.18.37-rc1. However, the problem
> > > > > also reproduces on current mainline as of this writing (commit
> > > > > 51cb1aa1250c36269474b8b6ca6b6319e170f5a5).
> > > > Could you please try applying this debug patch and send me dmesg?
> > > Sure, I applied the patch on top of mainline, and the dmesg output is
> > > below.
> > Thank you! So I messed up and "Input: rmi4 - fix register descriptor
> > address calculation" is totally wrong.
> > 
> > Can you please revert it (keeping the debug patch) and try booting again
> > and if the touchpad still does not work post the dmesg again.
> > 
> > Thanks!
> 
> I did the revert, while keeping the debug patch. With this kernel, the
> touchpad still doesn't work for me, so here's the new dmesg.

Thank you. It looks like the firmware is a bit sloppy and the new
tightened checks are tripping on it. Please try this patch:


Input: rmi4 - tolerate short register descriptor structure

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Some touchpads (e.g. ThinkPad T14 Gen 1) have buggy firmware that reports
a register descriptor structure size that is too small for the number of
registers it claims to have in the presence map. The remaining bytes in
the structure are 0, which with the new strict bounds checking causes the
parser to fail with -EIO, aborting the device probe.

Tolerate such short reads by dropping the remaining (unparseable or
0-size) registers from the list instead of failing the probe,
preventing the driver from trying to use them.

Fixes: 0adb483fbf2d ("Input: rmi4 - refactor register descriptor parsing")
Reported-by: Barry K. Nathan <barryn@pobox.com>
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_driver.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index a28eef1b765e..a58de7aad150 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -616,8 +616,8 @@ int rmi_read_register_desc(struct rmi_device *d, u16 addr,
 	unsigned int presence_offset;
 	unsigned int map_offset;
 	unsigned int offset;
+	unsigned int num_registers;
 	unsigned int reg;
-	int i;
 	int b;
 	int ret;
 
@@ -657,7 +657,7 @@ int rmi_read_register_desc(struct rmi_device *d, u16 addr,
 
 	memset(presence_map, 0, sizeof(presence_map));
 	map_offset = 0;
-	for (i = presence_offset; i < size_presence_reg; i++) {
+	for (int i = presence_offset; i < size_presence_reg; i++) {
 		for (b = 0; b < 8; b++) {
 			if (buf[i] & BIT(b)) {
 				if (map_offset >= RMI_REG_DESC_PRESENCE_BITS)
@@ -697,28 +697,41 @@ int rmi_read_register_desc(struct rmi_device *d, u16 addr,
 	if (ret)
 		return ret;
 
-	reg = find_first_bit(presence_map, RMI_REG_DESC_PRESENCE_BITS);
 	offset = 0;
-	for (i = 0; i < rdesc->num_registers; i++) {
-		struct rmi_register_desc_item *item = &rdesc->registers[i];
+	num_registers = 0;
+	for_each_set_bit(reg, presence_map, RMI_REG_DESC_PRESENCE_BITS) {
+		struct rmi_register_desc_item *item = &rdesc->registers[num_registers];
 		int item_size;
 
+		if (offset >= rdesc->struct_size)
+			break;
+
 		item_size = rmi_parse_register_desc_item(item,
 							 &struct_buf[offset],
 							 rdesc->struct_size - offset);
-		if (item_size < 0)
-			return item_size;
+		if (item_size < 0) {
+			dev_warn(&d->dev,
+				 "%s: Failed to parse register %d descriptor, ignoring it\n",
+				 __func__, reg);
+			break;
+		}
 
 		item->reg = reg;
 		offset += item_size;
 
-		rmi_dbg(RMI_DEBUG_CORE, &d->dev,
-			"%s: reg: %d reg size: %u subpackets: %d\n", __func__,
-			item->reg, item->reg_size, item->num_subpackets);
+		if (item->reg_size == 0) {
+			dev_warn(&d->dev,
+				 "%s: Register %d has 0 size, ignoring it\n",
+				 __func__, item->reg);
+		} else {
+			rmi_dbg(RMI_DEBUG_CORE, &d->dev,
+				"%s: reg: %d reg size: %u subpackets: %d\n", __func__,
+				item->reg, item->reg_size, item->num_subpackets);
 
-		reg = find_next_bit(presence_map,
-				    RMI_REG_DESC_PRESENCE_BITS, reg + 1);
+			num_registers++;
+		}
 	}
+	rdesc->num_registers = num_registers;
 
 	return 0;
 }


Thanks.

-- 
Dmitry
