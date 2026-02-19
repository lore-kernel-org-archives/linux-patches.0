Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB18A280329;
	Thu, 19 Feb 2026 02:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466667; cv=none; b=XfWocPt/X43szE4WIVykYHBHSuhrc95TpSDWG/0N9cQERTK1qqGoHd6zpWzjMa5WEZ3iYNDg+k5MaDRtKOKnXNRC+5GZOGv1LllBkUQrw/iR0jx65YlmuVrVtYU+oTBtaqS7x092B4pap2wH/1Lw+PeB1HDkO08DmN1bymncKaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466667; c=relaxed/simple;
	bh=wK3Ff6G1hJrge2afnpYAzF4xu1ONqFWIGxNJh5GYfA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/JDgXaMsDFiLTjwltzC9ezbRaGBmaJBbyHl8rjdBhTnROgf2VmkjsdOIEIbEFx4NqemS7xTSwmiVAn1a4UxE3nKAadxCHCPEMv0ixWsz7q6P+vpBRVK8EoMKzewvQ9FuZTlpf7GhFSsDtO+h7gd5QPByKNhdHkL9Hj6QDJ5Nf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N72f3pYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N72f3pYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B44C19422;
	Thu, 19 Feb 2026 02:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466667;
	bh=wK3Ff6G1hJrge2afnpYAzF4xu1ONqFWIGxNJh5GYfA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N72f3pYTh3D3I43BNYs/njtS2SqH+d1f9MfP1+jtrCF4DldGjzX+FGqLFzA/lbpur
	 vQT2nEdty9Vo/cwBaDT4ouPPdKcWau9ubBYxfeU1YNAg8IRzZ/fy/zERsuDEkeKDlQ
	 0bNFXNqXv3UYP3BWKXXgMG1K2CTIs/BT0SHVLmFLm0Up3ThC74tgUaxnD6A9YLSSl4
	 ktRbP5Kv63UKesX2AhaG7CmZoFZN46aTZkrEBdTpc6WAxZcSCopm8lg6MScKBw1/nS
	 b/sYFfEd3rnBLo5ZKpAR6Q50UUu5pZA1A75Q7lopaZ52zra8iJqZxp8QVBy0CnHTYC
	 lBd0u0KIOTY5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Diksha Kumari <dikshakdevgan@gmail.com>,
	Mukesh Kumar Chaurasiya <mkchauras@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-staging@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] staging: rtl8723bs: fix memory leak on failure path
Date: Wed, 18 Feb 2026 21:03:39 -0500
Message-ID: <20260219020422.1539798-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Diksha Kumari <dikshakdevgan@gmail.com>

[ Upstream commit abe850d82c8cb72d28700673678724e779b1826e ]

cfg80211_inform_bss_frame() may return NULL on failure. In that case,
the allocated buffer 'buf' is not freed and the function returns early,
leading to potential memory leak.
Fix this by ensuring that 'buf' is freed on both success and failure paths.

Signed-off-by: Diksha Kumari <dikshakdevgan@gmail.com>
Reviewed-by: Mukesh Kumar Chaurasiya <mkchauras@linux.ibm.com>
Link: https://patch.msgid.link/20260113091712.7071-1-dikshakdevgan@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The bug has been present since the original commit `554c0a3abf216c`
(Hans de Goede, 2017-03-29) — this is a long-standing bug.

## Verification Summary

- **git blame** confirmed the buggy code (the `goto exit` skipping
  `kfree(buf)`) has been present since commit `554c0a3abf216c` from
  March 2017 — this is a long-standing bug present in all stable trees
  that carry this driver.
- **Code reading** confirmed `buf` is allocated at line 283 with
  `kzalloc(MAX_BSSINFO_LEN, GFP_ATOMIC)` and only freed at line 321,
  which is skipped when `goto exit` is taken at line 318.
- **The fix is trivially correct**: it changes `goto exit` to `goto
  free_buf`, where `free_buf` is placed before `kfree(buf)`, ensuring
  the buffer is always freed.
- The function `rtw_cfg80211_inform_bss()` is called during WiFi
  scanning, which happens regularly — this leak is in a hot path, not a
  one-time init path.
- This is a **staging driver**. Per stable kernel conventions, staging
  changes are "usually not stable material." However, rtl8723bs is
  widely used and this is a genuine, trivially-correct memory leak fix.

## Decision

This is a clear, trivially correct memory leak fix that meets all stable
kernel criteria:
- Fixes a real bug (memory leak on error path)
- Small and contained (3 lines changed in 1 file)
- Obviously correct
- No risk of regression
- Long-standing bug (since 2017) present in all stable trees carrying
  this driver

The only concern is that this is a staging driver, which weakens the
case slightly. However, the rtl8723bs driver is widely used (common
Realtek WiFi chipset in budget devices), the fix is trivially correct,
and memory leaks in scanning code can cause real user-visible issues
(memory exhaustion over time). The fix was reviewed and accepted by Greg
Kroah-Hartman.

**YES**

 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 60edeae1cffe7..476ab055e53e5 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -315,9 +315,10 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 					len, notify_signal, GFP_ATOMIC);
 
 	if (unlikely(!bss))
-		goto exit;
+		goto free_buf;
 
 	cfg80211_put_bss(wiphy, bss);
+free_buf:
 	kfree(buf);
 
 exit:
-- 
2.51.0

