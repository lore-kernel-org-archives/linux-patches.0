Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831867;
	b=i9WYlT0mjPqYvj1ul2ukvE7yyJs7vfmIdoL5mEyJuDf3C1T1Yi8X2E2CVtE8+U08gYKx
	 KqecdW/kVhIvbml+GPgS0YcTyWZHeI9Y9adedyYhENRN57tUm08axTrGupUoP+XurNFmw
	 H5MZNxobBuSt0Cf/4kbyegqf8ZYsGu9PnYc5x6NLuR1FZTb/X9Pgh3rkYRE1yW0wd5yRH
	 lROGdubuU+v4jiGF8pXUjOi60wZzB+3TpzGnSk1AMSAwpIEqlJdomFcSXt1oK7yHo+lc9
	 IMNOY1wACmbPuLGuJFHOjs0Pzh53pfA43IQj7bcOn430yDb7uV4KcA9nV242v5wqTkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8gR0c1FKztNR2H4yp6YLV+UeL/QYyUwFRAGKCjbehnI=;
	b=ZxM+G+D3GECXMe3jKcd7iN3hdZvzvowvqsx15TrASzMpu9RuZnLFtKKipJIFh7+49iiN
	 l6BVQb80HyUWy1N3Eprml8SODyZ7HGlTZAh17YZ2VZD0NDt22UFxcZD6lfGlI+hMHg3cC
	 bDdvTjDYp5uf2whvnTPsw3vCj5EPzPmXoZfA3NyzjdYwk4C6XzT21BfWgiSBexgj9CRut
	 0NhQ82BqRBHhVXNuC/Hn11wUZzC8Mj5fcxVmWY5oRmpcGd0hJyN25q+E0Ob9iK0R5aeKF
	 Ey9wwa032PDPTewl9BHFTGZppVlBDG0rtz4veOSxl9tvfU3smQMNchi99/c22/34P1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBSBcA3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502C9606AB34;
	Wed,  4 Nov 2026 22:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBSBcA3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB17D1F000C1;
	Wed,  4 Nov 2026 22:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831866;
	bh=8gR0c1FKztNR2H4yp6YLV+UeL/QYyUwFRAGKCjbehnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBSBcA3KeuSQA8yEK4IFj/RHEIV4aUa2F341TpNXd9X6IeXDFqJPcF5CwIYyGA1UT
	 g/RKHycqDCjm/JO0k4eVmZkVFpnMwSdickYXOW1G3GMtAfaCM4GE1+Tz/2UYXYvnl5
	 2FkgmvAnSn1torj8YGvtuVuPNl+hl1Mx3qOUuBSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0963/1005] HID: roccat: pyra: reject short button reports
Date: Wed,  4 Nov 2026 16:11:36 -0500
Message-ID: <20261104211110.050688531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 493268f459bb6aeeecbc77f2204c11ad74d05213 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct pyra_mouse_event_button for button reports.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: cb7cf3da0daa ("HID: roccat: add driver for Roccat Pyra mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-pyra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -557,6 +557,9 @@ static int pyra_raw_event(struct hid_dev
 	if (pyra == NULL)
 		return 0;
 
+	if (size < sizeof(struct pyra_mouse_event_button))
+		return 0;
+
 	pyra_keep_values_up_to_date(pyra, data);
 
 	if (pyra->roccat_claimed)


