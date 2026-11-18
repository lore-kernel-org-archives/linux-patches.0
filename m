Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047840;
	b=jQAMejYM7Ih+/mW6z4eRoh4kl7eWIWd3OQf4RakxjnDZQ/H5AEIfvQcYZp8f3xySo7eP
	 hUiic30OANdzlgTQubAYoQjP/To4EyGRd9nr4khrp1Ssqoz9orNpuUm58pHE7jxYWUC3e
	 5R9C958iKFhbvPQQLh1siUwoeRhDG0fe2593XBDxc31n4AHYqm1Mm8ICZ+8S4msdQAlLE
	 bM3m4QjO344wZEGVOQX/QUmvOZiT/O4rSVT1bgk23Pmk/8DFWFOwdejwzNvj2cp3I4PtL
	 rzmOjoHdSctXJZaeQtIrTeg/WEhjNXaR4UzNY0I00bQ0V8STBeY8fDsLOSdLqS4Gx4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0u7b6dLB5PJAGNefcPfZddkZLOsa4qBdKQlfP23mN68=;
	b=J7q3lw8rsCggzSD6jI2BZfIQ/j6SpYZtpf0mZKubyDBEsNt09syHssvYCvWObVgR3C6a
	 ebXqam5bXZqjtANgLtxwbv6eRg5s6+rQYWD4IfPAx1RI8x45PRtnGynQ9mGqF8otZxKoL
	 xa44wlh23vzTnNkqe7bNJqtLSUrfkN4AcaG4lOwLghIJGpmd9Smlfa98qQCO74dOzzgt+
	 k9+6AQLjtBKjKF07ztlPIK3LKD+weST8By5py9GkZT6sc6723xewliw0gds9rT6KWIoMx
	 IDbDJHum6wJGqkG1CAxDVBA0MLE/iIYdbhEFy0wy2QtZg9aFdDnP1JZWQwx1+li8vKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a6kKmkwn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212FE606A32A;
	Thu, 19 Nov 2026 00:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a6kKmkwn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACDB1F000C4;
	Thu, 19 Nov 2026 00:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047840;
	bh=0u7b6dLB5PJAGNefcPfZddkZLOsa4qBdKQlfP23mN68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6kKmkwn6aBaoHfqF9dbtP7rTb67XLWsh8e3PaddKQKNJH1OfJIrM2WLogEuwQi/5
	 x96ytj/dx/gWAIDNRxgFNjleTEAblguxAxEVaWtuDl6+iBWmbHcEa/AdpLvW38vEtB
	 MSci7Cu6QKKRiOfMVI3K3VEB0Q6EPM8/vn0UFWfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1783/2857] wifi: rtw88: debugfs: dont vzalloc(0) when rsvd_page is read unconfigured
Date: Wed, 18 Nov 2026 15:46:57 +0100
Message-ID: <20261118150305.475470038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>

[ Upstream commit 81510c3d6f2199889a4a936d8cf8b9e05911b10e ]

Reading the rsvd_page debugfs entry before writing a page offset and
count to it calls vzalloc() with a size of zero, because
rsvd_page.page_num defaults to 0.  vmalloc warns about this:

  WARNING: mm/vmalloc.c:4019 at __vmalloc_node_range_noprof+0x9ac/0xa30
  ...
  Call Trace:
   __vmalloc_node_noprof+0x4c/0x70
   rtw_debugfs_get_rsvd_page+0x4c/0x110 [rtw88_core]
   seq_read_iter+0x132/0x4b0
   seq_read+0x12e/0x1c0
   full_proxy_read+0x6f/0xc0
   vfs_read+0xdd/0x490

rtw_fw_dump_fifo() would reject the zero size anyway, but only after
the allocation.  Check for a zero buffer size first and print a short
usage hint instead of allocating.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260827131244.35623-1-abdurrahmankaradag19@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 017783a1c2d9a..3a514aa8b211f 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -310,6 +310,11 @@ static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
 	int i;
 	int ret;
 
+	if (!buf_size) {
+		seq_puts(m, "usage: echo <page_offset> <page_num> > rsvd_page\n");
+		return 0;
+	}
+
 	buf = vzalloc(buf_size);
 	if (!buf)
 		return -ENOMEM;
-- 
2.53.0



