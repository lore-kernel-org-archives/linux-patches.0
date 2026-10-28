Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213465;
	b=0jPKgsk/1VnWQuyJeaP2dhLi4v21G9MnW1lA4lq+wkGG2nNSmdnj5jcRMPiTjiQw38EH
	 2qjwD1VBsaiAnMQuudZT+o4szIn0aL+COont+VEdtGRxUIHTALGrBApTGh2xWG4Fs3mFU
	 nTqa9EdlPP5JaF+U4oUf9+5MHF7F0qDIVkD6mnS1/BRDCljNMhtcThk9z+LjqSfCyiCAM
	 Ch7bPeaxzDODsmdpiBf3HbubWYjqzeUxeO3HWpjrqJT5T2SLb+UPmuGdrts8b/9Rt0s66
	 VMhoVAtxDw2i5sUI7xarnumGTWPIhkDjkNN9n64mBC4VsO8+cnazlrvewON4gPiU+VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4owXaLYm4QKex6De2JPAneIYhiWgqz3KfcGtJB5sY2w=;
	b=PqsZenduzYlvk7yiG8LjGMdoiE2ZlbDL9AKKGrb6NB65ijcxsPiShYXybr95RkOl1X1S
	 214N2OJjHtudRP/SLDpeSRxdhhvnwysg0gbFmlAJfN06q1M7jlr9Z0kzMmsf3ZA10JpE9
	 D3ys1q5sFK8eDYueno4OJmPovh5217YkyNwvU6rJhh/PO2M8j7GpM32IBl4LZKHskL2sO
	 jJGOSuQ762GuTXC2LXpvKXGQkbAd+8kL0wIolgaYrqwHnfDTj/QMcLcZvcFwAhQau01Aq
	 3aLQUz/Z16fj4mKT5fkMAM8WtXMEigPRzieIH0KmkUllCg6xDeWCOh/2BkbNR0Gi9wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kat0/dcB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134C4606A31A;
	Wed, 28 Oct 2026 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kat0/dcB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2235C1F01825;
	Wed, 28 Oct 2026 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213464;
	bh=4owXaLYm4QKex6De2JPAneIYhiWgqz3KfcGtJB5sY2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kat0/dcBiC1O3oxvZRqFD2mXUPS7KiGJ5B33OKBrb2HIa0TVIeFXcnl8FtJPuDqVK
	 tFkCiPNZ80mKGALIpLd4f06Yqafdjticx7myQoQ4pygCQTF7BUzHX95QqtEapU8jMS
	 t0QQVE/XdWzcaJEc3yKhGYa51mxhpj/PsTZ8oxrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0514/1887] selinux: fix data race on AVC latest_notif
Date: Wed, 28 Oct 2026 17:43:30 +0100
Message-ID: <20261028170511.012619123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 1ca924044bf0de879a1648be93a56939652267d3 ]

avc_policy_seqno() reads latest_notif without holding notif_lock, while
avc_latest_notif_update() can update it under that lock. KCSAN reports
these concurrent accesses during policy boolean updates and permission
checks.

Use READ_ONCE() for the lockless read and WRITE_ONCE() for the update.
The spinlock continues to serialize the comparison and update against
other writers. Reads made while holding notif_lock cannot race with a
writer and can remain plain accesses.

This marks both sides of the intentional concurrent access and constrains
compiler transformations, without suppressing checking with data_race().

Cc: stable@vger.kernel.org
Fixes: 788e7dd4c22e ("SELinux: Improve read/write performance")
Reported-by: syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a7f7cb0737bd91aa698c
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
[ sashal: Adapted direct selinux_avc accesses to the existing avc and state->avc pointers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/avc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index dcc8e1df4d7c5..e26f9b01b7305 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -589,7 +589,7 @@ static int avc_latest_notif_update(struct selinux_avc *avc,
 		}
 	} else {
 		if (seqno > avc->avc_cache.latest_notif)
-			avc->avc_cache.latest_notif = seqno;
+			WRITE_ONCE(avc->avc_cache.latest_notif, seqno);
 	}
 	spin_unlock_irqrestore(&notif_lock, flag);
 
@@ -1202,7 +1202,8 @@ int avc_has_perm(struct selinux_state *state, u32 ssid, u32 tsid, u16 tclass,
 
 u32 avc_policy_seqno(struct selinux_state *state)
 {
-	return state->avc->avc_cache.latest_notif;
+	/* Writers hold notif_lock; readers only sample the sequence number. */
+	return READ_ONCE(state->avc->avc_cache.latest_notif);
 }
 
 void avc_disable(void)
-- 
2.53.0



