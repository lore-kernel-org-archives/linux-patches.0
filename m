Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060915;
	b=G4XkVxfmHSsS94Y21KeqrsAYmB4SdWgQ8+hOAbTh5OjZk9iDFR/dBfRwUSfPsrz3GSs5
	 m8qF/H6qrXTBOU5BlW6DpbWzuZsDAChdZJA5kt5MvdKDmdvpyjXTlO1OxcXITUGC+imlq
	 hwv5qjsczwVg/WvWf8J2RgXQto3CRyedjSOEhtEyR+juCX2byB+bvw2XBKo74GcsT+H6w
	 yzaBoPBOSHRRYKyvSE9oCVBYr5Z7QTLvVudOGI/yx7RseYa0YkUOZ6wfpxLDQuD5cyx/y
	 wsOmatyur0kRxf2t+SC3nnRFFt7Uo6bHw3T0XZIwL616Ct8VJcVW2P6R1/7znIBz8fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x9o6ybrOTMPzmNTEnQG9mHVRt4EV5AWgpeKRuUlCvLw=;
	b=aAeHQ1QGrba4+MaIhuZHAhFiUHDLbnaA0HjRYxrBf0zP6QBSjXySUuE6uI+x60hpJPih
	 AEXIyffeQ7G6PBinol9k7cEFZRsS/5F2eZVdwlFPJGyOfJB4k3kxn+owxZh5kK2I5+NKj
	 8F7MR1eTC40uIXvaB2ulKtFOpZ1kRHScY9V8tV4b/uhK59OC2HOQKrRYGqKsK8lBZ6P66
	 AFZ8utzOUL10hzdKEp6Dk6DBAl7LPEZoRQ0f+yF5IeayfJ92dwPvRN4D7gw7tG41YvP39
	 cWfBYZ5CGeQDRuka/xnWAUDEHQ79fy1iLh0bF8X2czJ8GW9H2ccKBY0m+hJttLwLssQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SZJ/aKND";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000CF606D809;
	Sat,  7 Nov 2026 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SZJ/aKND
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9881F0089F;
	Sat,  7 Nov 2026 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060914;
	bh=x9o6ybrOTMPzmNTEnQG9mHVRt4EV5AWgpeKRuUlCvLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZJ/aKNDT2TAfdtbMzT6DFd8J3Bc601OR7so7PfsRWou+58yKvVgwhLTU9eOPJVw6
	 Txjx9/36AmgUwKdI3D9hGQllW2DFBoxYibS14exqlIhOO/caHSLICqNFyPW6WlK+XY
	 6Gdgvc4jMf4NDo9wa2Az/O85IKunLzSFlhDX4jJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0283/1536] md: add cond_resched() to md_do_sync()s skip path
Date: Sat,  7 Nov 2026 08:38:19 -0500
Message-ID: <20261107135005.612042604@linuxfoundation.org>
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

From: Yunye Zhao <yunye.zhao@linux.alibaba.com>

[ Upstream commit 162eb5ba791f6260fdaabae75fa2df20134f67d8 ]

When sync_request() reports a skipped region (*skipped == 1),
md_do_sync()'s main loop advances the cursor and takes an early
continue:

	j += sectors;
	...
	if (last_check + window > io_sectors || j == max_sectors)
		continue;

If the personality returns a small span per call (raid10 recovery
returns only 128 sectors), syncing a large, mostly clean array iterates
this branch an enormous number of times without ever yielding the CPU.
On a non-preemptive kernel the resync thread then trips the soft-lockup
watchdog:

  watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
   md_bitmap_start_sync+0x6f/0xe0
   raid10_sync_request+0x2c9/0x1530 [raid10]
   md_do_sync+0x810/0x1030
   md_thread+0xa7/0x150

Add a cond_resched().  This does not reduce the wasted iterations; the
excessive iteration count is a raid10 problem addressed separately.

Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
Link: https://patch.msgid.link/20260723135535.101995-3-yunye.zhao@linux.alibaba.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index db8df74fcf67a..634b68b6632ea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9293,8 +9293,10 @@ void md_do_sync(struct md_thread *thread)
 			 */
 			md_new_event();
 
-		if (last_check + window > io_sectors || j == max_sectors)
+		if (last_check + window > io_sectors || j == max_sectors) {
+			cond_resched();
 			continue;
+		}
 
 		last_check = io_sectors;
 	repeat:
-- 
2.53.0



