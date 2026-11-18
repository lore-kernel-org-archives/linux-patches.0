Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052786;
	b=sNI3O+LkKXvqpLYWYPnMpA9GtnOM6Vskgugi0jR4EEV2Xm4yAG3jm61jb/ZTCh3jcKjJ
	 rCzvrYuUgk0oB0PBJJ85umvVbzw7Xpqtd/nGU+ua1fLmBuZepnjpOfpRF7emKFS6tDqRu
	 35tBDCbjobhuPFrR1z4l4eWUEQu0b+DZOYZ1gzk3ci8Zr3monSeTBkcPfIiy2+ANDroIu
	 HFzqQ87Z+s3eJswKnAIECtu2gI/bF4TRzcqA2z7A0R5N/xicfcZf+yKhYO1q8v6sdh2r+
	 eRPviTJTyAgk5tVKSUWGTSoN4T+BTThA9OKuDCfV8gp7TOSVUDcdNQ5m7oU6o4mXoRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1yCEYXFp1d/j9gXnnnzFJGuuZabW9Y05EJN2rKyxX6M=;
	b=yAhJjnrwm5oapDdOtSNBzdLiQtlBswGy2cq+55bjw6qTVpQtHRMz6RxenhMIIDX2gSKW
	 pfaWRc2zs5fbaKESCXq1KFog6gvzp9iIq5/S0ro2yCc0u/q2EDYdMXoHOi9dgMVGEyNz/
	 9wweYRUa/CmG1zDBucYHx2vQppdLngQnh88khAylvjPZ53lNHAyx7/zIO/L6NXRfcSRox
	 caKh1LsiYUCKZG3AiBun1kkMy+OhfZCJBIRL29/YwasGRTScb7mcMqu7/7iksl5nSnp4N
	 7/BMwD2s855Z+I+QCvuePTGNIa/6ZXo1waOcsgoi5sOJPc3kXMfd90cW88vfXw0eMrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GohkAaN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7B606A31C;
	Thu, 19 Nov 2026 01:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GohkAaN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78421F000C4;
	Thu, 19 Nov 2026 01:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052786;
	bh=1yCEYXFp1d/j9gXnnnzFJGuuZabW9Y05EJN2rKyxX6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GohkAaN8NWpgcvMXjHms1BCdtvBfF1bcfjO3ND79PvssXsakR+ywzt7EfKT7AuezY
	 RIg0kmziQKUoAL1qNjjzlXmlW7QUFEna4zEgvO0p8ZhwgZPbvNSH8kl+WpQFGnqhYM
	 Ys5dctE8WpW1820Z5l9Yt6iIvmEQnsPRLQD1ck60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0689/2214] writeback: clear old wb dirty state after inode switches
Date: Wed, 18 Nov 2026 15:39:25 +0100
Message-ID: <20261118150039.294341844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit a396fe9f74ea367ae3fab2dcb70b24e83db9f0cb ]

Switching an inode to another wb updates the target wb's dirty-I/O state,
but no longer checks whether the source wb's dirty-I/O lists became empty.
The check was lost when inode_io_list_del_locked(inode, old_wb) was
removed to support tracking clean attached inodes.

If the last dirty inode is moved, WB_has_dirty_io remains set on the old
wb and its bandwidth contribution remains in bdi->tot_write_bandwidth.
This can keep an empty wb scheduled for periodic writeback and overstate
the total bandwidth used to distribute writeback work.

Call wb_io_lists_depopulated() on the old wb after the batch of inode
switches, while its list_lock is still held. This clears the flag and
removes the bandwidth contribution if its dirty-I/O lists are empty.

Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-3-sunjunchao@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c6c2dad201564..acc639682c7d5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -509,6 +509,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 		}
 	}
 
+	wb_io_lists_depopulated(old_wb);
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
-- 
2.53.0



