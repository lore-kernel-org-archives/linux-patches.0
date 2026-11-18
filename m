Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058964;
	b=Ror5Hk//melUmfNCFDZVbVLMJeZmH3oVdEt8qDJRn20LnP2eEKsQl/e0LkiUZIYFf8w2
	 TAInWW7HMBSsqNDtrtDningqBjX1OLtILRCXJRBqAlsXjRfWdj5VP0jZaeWFlACTwFj8c
	 WtL66xK3IDya/y0fddB6TmORKIWLBSBHEGhPTkbC3gT0Kqb5mUH5Hmy+XXSn/k+Nk632b
	 T3r665hvoq60JeR/J4HI0JA6jT1cJNX0xbAfxteeCbXfXJcku2jmbZLxJsI79lCeFhvW/
	 yUejng5cXWgfjrsJm8bjJ5s3eK+y2XUG+GYYr6wfdN1OT01k180qiTZbZFm1zad0ptQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sEQH1xhOoxOaG16pNTUOdPtTSmcRRsTb9KipikJsakc=;
	b=FUWxXQyCzaGbVm2xrZmvy7nJGIKaF0eht0hMH822G4acZLBlNxREiEvrR0rKXtrK3JS/
	 5/DWUgoCpzGUMVaJtI+SMPSreVhKedT9WcQh7I7EdQCXUPq3bWLhAYIbk7EGjI2kV5XcZ
	 8Wlk9mOucjUyfZOOwTelvMqI/Yx2c49zA9/m4aWyIyX6PgP+1UBVgMnyQEVJggLb83wz+
	 q9R9Dq1f722xZFUuCIQZmlQoXJ216jIGB6TbyA4D+vTlRYsyf0vOsjWWwjZmbp42YD0JB
	 rgG87LHHdxPEZISw5qwp//DTb1mJ5P/jOtsIzJ7HCMLCQuUrXWJRhDRe6L8BQtA5XCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6fudvrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FAF606A325;
	Thu, 19 Nov 2026 03:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6fudvrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9371F000C4;
	Thu, 19 Nov 2026 03:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058964;
	bh=sEQH1xhOoxOaG16pNTUOdPtTSmcRRsTb9KipikJsakc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6fudvrFAUA0OVdgxo7WGr1wki5Wo7p3BnG6OXOrSNyLwfQZy4L8pga2YCyNX4gCs
	 JQppdGbBPzgeJiLeRv0iliWNQ3zbjCXdHrjJU+TNGpk5Iunzy+W6bumIiobt+e02yx
	 lz1Q5qMizV+nQbtWPXmDsiz7WnQpqSbuZpLm7Cr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0674/1848] 9p/trans_virtio: reject mount tags longer than NAME_MAX at probe
Date: Wed, 18 Nov 2026 15:45:12 +0100
Message-ID: <20261118145944.065805025@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 5bfef2b6dafe83fe2d8d210d54093a8f48cfc97e ]

p9_virtio_probe() reads a 16-bit mount tag length (tag_len) from the
device config and kzalloc()s tag_len + 1 bytes for chan->tag with no
upper bound. A malicious or compromised host can present a tag of up to
65535 bytes; that tag is later copied into the single-page sysfs buffer
by p9_mount_tag_show() (memcpy(buf, chan->tag, tag_len + 1)), a
host-controlled out-of-bounds write of up to ~64 KiB past the PAGE_SIZE
attribute buffer.

Reject an overlong tag at probe time. A 9p mount tag is a name-like
identifier, so bound it by NAME_MAX (255): that limit is independent of
the sysfs/seq_file page size and is far above any legitimate mount tag,
which keeps p9_mount_tag_show() safe at the root without hard-coding a
seq_file implementation detail.

Fixes: 179a5bc4b8cb ("net/9p: use memcpy() instead of snprintf() in p9_mount_tag_show()")
Cc: stable@vger.kernel.org
Suggested-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <20260627211012.4042372-1-michael.bommarito@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_virtio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 36b5f72e2165c..fbfeb82ed632f 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -589,6 +589,11 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 		err = -EINVAL;
 		goto out_free_vq;
 	}
+	if (tag_len > NAME_MAX) {
+		dev_err(&vdev->dev, "mount tag too long (%u bytes)\n", tag_len);
+		err = -EINVAL;
+		goto out_free_vq;
+	}
 	tag = kzalloc(tag_len + 1, GFP_KERNEL);
 	if (!tag) {
 		err = -ENOMEM;
-- 
2.53.0



