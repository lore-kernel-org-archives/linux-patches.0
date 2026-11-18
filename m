Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034065;
	b=vi9Zy7e57iY2IrmNrojS9zCT2mDu13Mcn0xUoAmPsIqj15wuGHnKRobsf3p2KtCYNF86
	 eHFlVQQXsesjxGnPXszexWqb0hVxIkYSgEgUDp6+AoOvSMyug2H/7Gnb9h7ehSqKTEG95
	 T/Q8mJCaaef7++7NGlbqPTVsbRyP7lctPDDgldiutZpvo7MT+JJCpTIao5URImMgFJaGC
	 w2J2f6GHrXoVpfABPO3ljNqGoWIA3lhHOH3Gt15KoGlUAkK6L9r09kbZ8/+xrl792Q8aA
	 1mCjWtZf2T+xDT94tpJ+s28E8BPrrJw/ew3pOz+rzLG4Jift8lkLMDIhSXlZlKc6ojw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fR4Mx/Zj12oeBSh5gFzQRjeMldiijhgs0Woql9P4rcA=;
	b=MrhzlrL+KXqGXGnFXAoBuT6lDFsIqeE5K8FLoeumvfTDFgF8douk8SBXLnoONnxsdJXD
	 adqrE9F1YAv2/Obf/KDFxxIie1GvHpDSaf0oRNIJXtrNvNAe6ESGJnd1yRgzTe2dIe2ys
	 iYP+mvWG4AQfIYNOWlqHfaMOL8Ca8SGnTkm3qoj+CT3XrFRY0JaHT9ODwimgul64i7l30
	 XEGzdiBPoTPVxFp79PvEi0xfmuF3jJgc36tXTO6mw9r+/C4gMo+fy2nWJBh1Bfgb/7nwa
	 GZcgWvBLn3YYms4UTOKBDhPj94WYug6wy3njK4WkKzwKOA70D+jMSBULQjQjkLwSCRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/diL/0Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63189606A32A;
	Wed, 18 Nov 2026 20:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/diL/0Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60921F000C4;
	Wed, 18 Nov 2026 20:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034065;
	bh=fR4Mx/Zj12oeBSh5gFzQRjeMldiijhgs0Woql9P4rcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/diL/0QWm7ke3vGQ3nGW8RJsKxGYFgmNjKTtr8TAsze/d0VVjsnatiARNfMVbwJt
	 ssNJz5EY8Hwgjj/r47oV/0PPuhNikQ31486AH1gRMOQWjwL5if8BgL9UfB25gJ9JIt
	 BZLKAqXfbIEoexdPY+1EuGynhQlH8Qbhd5Mr2xaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0236/3318] HID: rmi: check report length before trimming sentinel bytes
Date: Wed, 18 Nov 2026 15:14:18 +0100
Message-ID: <20261118150322.178774698@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28a3e326fad2451bdb66b747dd1f7ccbb900eed6 ]

rmi_check_sanity() trims trailing 0xff sentinel bytes, but its loop
reads data[valid_size - 1] before checking that valid_size is non-zero.

Reverse the condition so the length is proved before the last byte is
inspected.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 8788192c09561..cd3173af5d7bf 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -386,7 +386,7 @@ static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
 	 * such reports here.
 	 */
 
-	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
+	while (valid_size > 0 && data[valid_size - 1] == 0xff)
 		valid_size--;
 
 	return valid_size;
-- 
2.53.0



