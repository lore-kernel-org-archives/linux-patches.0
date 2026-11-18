Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061213;
	b=x8QS0zbioYTeuUisejNshPWSYbbMBjnYR6LLU3n26R95lThkrDWN1wPOJbn9oPtTtflI
	 VzQ2zRGMOULeKfvtEqr+jH0aeAn8j5IKmg/1ms2wusVPAUAxqbC9TmS7ho88kyAw62CAO
	 xssuiDlmuURKwyFf4zIdnLTBynWlvXmQNTCkmuF2RTkIaEOK+hImFlrEW4Yu/2l314U+2
	 OMqKh+LNH8LvZ4YKKfCmPczECm16/6uqVjR/VEBR2U/uDFRp9Hh7oG90L3lWKNPyDfsU1
	 IjgnubXjh9sw+gXO/rF2AL04CJ8H5JLODnuBHETrrw/7KQmM8NeDYeYD63YntM+vbpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fRpnjfyn0WMt7OG3a+DP3ifVHobx9VFh3zkthLBVLJI=;
	b=WxRzTAB2t+64ssaPHWipLQwLUCRVZPwlYJr0V6FJIof21hDMKww0VCdEXOnOBBtqmpDb
	 /+nmposFxfLzcCL0TpBQVCIBBQ6yt+0zUyJ9CfivZfqns8TmOShDNPSBVi+Pmq7UNwZrP
	 KIBLMsb8l87n6FA+4H0h1ujpMUk9MH6Qobh8vMfiGtrwdLu8C6n40Ki7caKa7/x3bEyGP
	 KEc7IFEbQCUezFFkqs34US3C/8x9D3rHthmBC1aZNLyo4euAxAKfiu2Yf66OeykTTDcZ0
	 lMrIQ0TFICK9lUNsHRwpfoaAg6TiAZ2QzP2jgJm/9YTJLUJHi5gJyaQ+c48AyhLD0zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBAlvcrf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B816606A325;
	Thu, 19 Nov 2026 04:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBAlvcrf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E381F000C4;
	Thu, 19 Nov 2026 04:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061213;
	bh=fRpnjfyn0WMt7OG3a+DP3ifVHobx9VFh3zkthLBVLJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBAlvcrf307DNW/TzYK+vgDzCfv2KyNxmHtSinM6RTkOdZAS1QR2oOssaAY7ncaA6
	 Q8Xm7eplnU8pQEdnn9zHXltT5Sf65CoH3I16OoUIX880yDUutU+55GakkWrX+frnpy
	 KJRmaM16WSXcaqqI/gpn5VgeAToAmwpw53mtwewk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1473/1848] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:58:31 +0100
Message-ID: <20261118150020.964945911@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f94595252b318a9ae3c01d78b3bcd33b01b1c082 ]

The "buf" buffer is PAGE_SIZE and allocated with kzalloc().  We store a
string from the user in it and then pass it to sscanf() in the write
functions such as tsf_write_file().  The buffer is only used to store a
number so we never come close to filling up the whole PAGE_SIZE.  Reserve
the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/909ea7a88658b5e7c183bf0fda31687a91d73818.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index e7e4293c01f22..35f257d6c44bc 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -263,7 +263,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



