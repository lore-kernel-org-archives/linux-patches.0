Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044757;
	b=EiHXiXrDhdOn9gn7wUs4YkNAX3ObDpVwsCVFW2c/0Q0euE0wJ80gd4U5b1fzWZWOHGXI
	 MvCbDGn6aBWWPyXpVzX6hlXnHdYyoGiRMUsQ9G9YLKeJvB/R+icW/jNrWFmzssx2Eapvr
	 TQkLIZ/uOOMnnYDK8omTX/N4SGG/GdXxm2c32ujmvdhV/f8IkZXG0tLU2gjhVxdPU3V5U
	 atwXQGjnxhoePlZdj6gpdbNJG0jnnNGTt+p8dEo46ZKezu0jAXh9soRVc8Nx1vZ0HxK8D
	 ZpAsP0ZiLfqgydMnX3wX5T4MkaoniIk/Uw3MFER5t4jv0c0xaW36EsZpt000km5XsUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qZXgXpLrxIVa65juZ6zfyUL+GoQ2A8p56w9TQibRQSM=;
	b=ehrL1Y1neU1TBBLkD5m5u6ZiDPiz9a4TZoZeHsnqFqj0IONvkH8QGkUW7NiDZcWQN7jr
	 MKuN1c1lVq+wdnUJQwKbAu7SlhH+aDoUvnomI38NOo4EkDE/Cr5H1d9MY+OiLWGb130Ry
	 /ili+wJxps6rvGGnSTiBQz/CW7uqxfO170KI9hk5yVt0N111zCapqVFa680pSNsVFdKjT
	 rigOqqf7glaWDAqAcP2ZBhSvBm0sevDoVgIAMhH/vW4aMVfZqlIfp35/lOE3bzdAjLO4A
	 iyy3lMWv71sJx/Q2LdTDzGcXarNYJqi7Fr/ohDbjNUx45QvcDjkjO8fHZMcQa62byKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0bpX3Ga;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B260A383C;
	Wed, 18 Nov 2026 23:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0bpX3Ga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC03F1F000C4;
	Wed, 18 Nov 2026 23:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044757;
	bh=qZXgXpLrxIVa65juZ6zfyUL+GoQ2A8p56w9TQibRQSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0bpX3GaphJD7p7RB6PtA9R+Af55oeQA7Gms0GuFph+Yype8XcV48gRzobm90QD+K
	 mFJnp3ezazE4FjgQZXYA4ENXiJIaNSxeFDK2UnVc+Hvu8RA4d6UznlWeOC1DsXnJ8I
	 NmRXpNrfRYUfhKyGl0cWQBguB6mydf1bgXRCqcVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0630/2857] HID: zydacron: validate key report length
Date: Wed, 18 Nov 2026 15:27:44 +0100
Message-ID: <20261118150224.185463999@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 9932c9af185f8586e883d44ca562c12f4487c762 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  zc_raw_event() verifies the report ID in byte zero and then reads
the key code from byte one for report IDs 0x02 and 0x03 without checking
that the second byte is present.

A one-byte report reproduced the issue under KASAN:

  BUG: KASAN: slab-out-of-bounds in zc_raw_event+0x54c/0x580
  Read of size 1 by task hidtrigger/93
  Call Trace:
   zc_raw_event+0x54c/0x580
   __hid_input_report+0x2ef/0x3a0
   inject_store+0x479/0x490 [faketrans]

Require both the report ID and key code before processing the report.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: d0742abaa1c3 ("HID: add omitted hid-zydacron.c file")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-zydacron.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -114,6 +114,9 @@ static int zc_raw_event(struct hid_devic
 	unsigned key;
 	unsigned short index;
 
+	if (size < 2)
+		return 0;
+
 	if (report->id == data[0] && (hdev->claimed & HID_CLAIMED_INPUT)) {
 
 		/* break keys */


