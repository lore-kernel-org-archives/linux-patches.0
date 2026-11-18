Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046556;
	b=HLM522fCZr5DqDQIwpS/ft9ByGTyY60jc49f4JPyfmcAsOCIHLX+Yn9uFqLF657/2ai9
	 XaaQANWOoR4xNOUi2eXqONuIZ/akgtsmiuEukjI2xX8vqxxwpWIorTkT0WBfQhhVAA7i7
	 PZX788JMcDOYw36/GxpxIG0vlviN1Vs56D/NqjmmvDV6iOimKsP2RpZ66yQplomaSahIG
	 hWHBz4rQ5OSsTJsRwd97Wt/pnwf2k9M092se+OB4uA1jrloF+pvDOrDTmais5XvlJG7uo
	 sdc5K1Re07CsOZdTpxvqSsw65EEUvEUCQ36V/BCwS0JPIKQtSb25Ry4UpAlprVHo6MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eM7l+MGPKg4t9xaJJLD4Eq2weQTuAFS7AACsmSrGGVQ=;
	b=m5jdUdcKFIoZn0QDFzDajRgC7M9eVPY1IwcRJAUdskrcNAwQv4PcXRjAhQ05gnIo3R4o
	 shY8OlyULD0bs9gSjTjLGMo0rSCcrrtnJL8hNHReKxLKXyrOTe6w8QCEZtVlkT8+3w96o
	 hULoQQQsxBURWQbZLcZngObpumiRw7/03FP+uHoG3TqKr7/Dv4qWzbLuiGq9w7CgmXxFB
	 rrUhWWQZPWkrJeo84P+4r1AMnG9mC+6VyQqU40F4LxT2xw4yi3MKH9Dswgr2ydgdTFalw
	 f6gQEu8kgHw2vj7tRW3rEJpHvKYxkRbvgJ0WGw9E2R/WyYSzQ1KTFl1z1moxAXP0dSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI7wL4NE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC97606A334;
	Thu, 19 Nov 2026 00:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI7wL4NE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726321F000C4;
	Thu, 19 Nov 2026 00:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046556;
	bh=eM7l+MGPKg4t9xaJJLD4Eq2weQTuAFS7AACsmSrGGVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SI7wL4NEsJlOZgmWuP8JghuoUo5WvQk+qQzWsCo/5jf9OAP7kXT++PBg/+OQ9EC1X
	 YMdvS08uTccmfEdp3eOXRwqICJE4eRSOvas/tvXy9I+vabVhiPSi11jRLLB2KqkUo6
	 ZB65/eLw+6X/BnyuQ8fzo4VoHAVjpaaGPJIVq7WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1322/2857] ceph: clamp the inline data length in ceph_fill_inline_data()
Date: Wed, 18 Nov 2026 15:39:16 +0100
Message-ID: <20261118150249.048590384@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanglei Zhu <zhugl3@xiaopeng.com>

[ Upstream commit 9c1d14d3b66b3e1dd96ee664c0dd2548f2b77a52 ]

The MDS decides how much inline data to attach to a reply, and the
client parses inline_len without any upper bound: ceph_decode_need()
only verifies that the message actually carries that many bytes.
ceph_fill_inline_data() then copies the data into a single page
with no length check, so a malicious or buggy MDS returning more
inline data than the page can hold writes past its end.

Clamp the length to PAGE_SIZE so both callers, handle_cap_grant()
and fill_inode(), are covered.

Cc: stable@vger.kernel.org
Fixes: 31c542a199d7 ("ceph: add inline data to pagecache")
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ Adapted for 6.1.y: folio_size()/memcpy_to_folio() → PAGE_SIZE and the page API; this tree has no pr_warn_ratelimited_client(), so the warning is dropped. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index aed58cc4b0f9c..11bbcda371124 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1689,6 +1689,9 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 	dout("fill_inline_data %p %llx.%llx len %zu locked_page %p\n",
 	     inode, ceph_vinop(inode), len, locked_page);
 
+	if (len > PAGE_SIZE)
+		len = PAGE_SIZE;
+
 	if (len > 0) {
 		void *kaddr = kmap_atomic(page);
 		memcpy(kaddr, data, len);
-- 
2.53.0



