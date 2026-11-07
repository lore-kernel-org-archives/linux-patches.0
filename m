Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061785;
	b=ZHxNrSESAzw2+5213caKr7DF3j1ZtzX4F2l4AeW45H9BgZUCWvk2eWXCfpUnSbBGHdmE
	 nfjlBVToPEWeVePHoyp/hGUnO4gv/mJ6ponXkue6xYz+aAAnFojDhjWsAvIgho/RMLoVd
	 dR+QjG93sYxYa5RyBoPp91EPxiGFgYWZjjpPEhQxHSahM6jwYd81Ol0LQuNIAtzJGSjIw
	 qFc675DH1xdT3EWelcoKezUy7I6Y8jbr3u3oNk7vTSGNgg0+LUdSQiqqmm68WoViEIw+7
	 u4C+61KT4vs045EJkL5apjq2+L2gB1G2bk3T2GWmII1OsbsudTvTyFqDthZVOSIG+lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r6T9u/sR6jPDSmgoZVHhVxZ7JoD9+V0FCUXgCWh47Vk=;
	b=u3gRnTfTYDEH7A2xhatHSZcgWhh6LW/9yTCp14xvd0SWpqCnGgzOigDtG1U6K6AWqGcq
	 ayDmIxqbWtLP3AazFmOAW+guDGJ6cYjQRJA5akRVGw0PxRCsRSbSkTN4EfRUqbbGyE55y
	 U/URklILDm214u/Fvng2JnGTcO9J6UcPC6iuPzSJzyyRYbuBGOoJtuj2VEgNRJHD92dmO
	 eHnxAdDOqvqrUx9lCCHMLZPND733mOnttGdUY//VFJHKSPppAr0dsuS9DnmWBSd8FjOdW
	 hKys9iWFkmjXchZsx47nAGyq7qWzW0gNUBAYMbzBVEur8Ky72G7VEB6QCZswaKN4naA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kX+NgITS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD53606A32C;
	Sat,  7 Nov 2026 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kX+NgITS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196611F0089F;
	Sat,  7 Nov 2026 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061785;
	bh=r6T9u/sR6jPDSmgoZVHhVxZ7JoD9+V0FCUXgCWh47Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kX+NgITSsFcKWyVrSszfB/Kcek2RcujLjMSWF2MEDnDp3UfYxFOzP1Xi5O9d2137L
	 jh8Oi7ebOVZS9FAk6kIqlhMSv0tw9uUNWJixMRZHW5vadAG2FeyLT4UxFWXfVt8E8l
	 BvwTuzJ2lTbYTyF0YvkPHcKIN+sL6E4qM7hzjExs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0815/1536] HID: mcp2221: validate response report length
Date: Sat,  7 Nov 2026 08:47:11 -0500
Message-ID: <20261107135020.435463399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 1ae40774d386b7a51e4799200106429a7e14e8ec upstream.

MCP2221 responses are 64-byte reports, but mcp2221_raw_event() currently
accepts any report of at least four bytes.  Several response handlers read
far beyond that minimum.  In particular, the I2C status response reads
offset 20 and copies ADC samples starting at offset 50.  Other GPIO, SRAM,
and flash response handlers also access fixed offsets beyond byte three.

The HID core invokes raw_event callbacks before validating the report
length, so a truncated response can cause an out-of-bounds read.  Require a
complete protocol report before dispatching any response handler.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -766,7 +766,7 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
-	if (size < 4)
+	if (size < sizeof(mcp->txbuf))
 		return 0;
 
 	switch (data[0]) {


