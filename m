Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8674C21CC71;
	Tue,  3 Feb 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770134413; cv=none; b=r79zdzqBZppUFn+T/7M2Zm2UWj/o/BQcFGPk6zgocHr6HyGr6yr6AySZoxMB/s/HQEURVlpEkgNBHLR6pVmRt1Tzw/aEJm41a/0U7Xr6SVFZYI1XnqgZGvKw7zrsnCkPqLhJ9WF6HbigxsoHzoZ1Y3VK3zsshV1ndsjVqLNQX54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770134413; c=relaxed/simple;
	bh=iazE4s92ZvYTkL4sF3dmjaq7r9G5CAIJHKOQaPUZqUs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-Id; b=lbPb8gGMptWRLPsgWUTjDOwrZOuihCBum3HH9CYNBiJlu/J8UE5RFjMzYVnlOneECEpiXReepBq7XyjSdcVdEAS+2tIU8NSlie1vts0lrTMDrE7tJj/v63PgKOoAyDV8tEuOPokvDZMN0qBFYJOXroMNBtSuc4n9BIpVspm7Mn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTAr864T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTAr864T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD80C116D0;
	Tue,  3 Feb 2026 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770134413;
	bh=iazE4s92ZvYTkL4sF3dmjaq7r9G5CAIJHKOQaPUZqUs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=jTAr864TejpcOygyu9a8/2euvWYEJROJkNa8f/3dWVKTYh2N3/rBUMOBoLjbMAksa
	 2Lsqd/Vt7gfBFeZ4CkBYW3/XXV6tfjAl90y45N9WMJQ0c5plw8mM16dAsebAuC0u2e
	 2Pxj0f2EKWMDgSt2vM0bJEoSS4+kQsmwHxvjQpB8=
Subject: Patch "vhost-scsi: Fix handling of multiple calls to vhost_scsi_set_endpoint" has been added to the 6.1-stable tree
To: 1468888505@139.com,20250129210922.121533-1-michael.christie@oracle.com,asias@redhat.com,gregkh@linuxfoundation.org,jasowang@redhat.com,michael.christie@oracle.com,mlombard@redhat.com,mst@redhat.com,nab@linux-iscsi.org,patches@lists.linux.dev,pbonzini@redhat.com,sgarzare@redhat.com,stefanha@redhat.com,virtualization@lists.linux-foundation.org,wh1sper@zju.edu.cn
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 16:59:10 +0100
In-Reply-To: <20260202064719.642351-1-1468888505@139.com
Message-Id: <20260203160012.EAD80C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

20250129210922.121533-1-michael.christie@oracle.com>
Message-ID: <2026020309-supervise-astride-d790@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    vhost-scsi: Fix handling of multiple calls to vhost_scsi_set_endpoint

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     vhost-scsi-fix-handling-of-multiple-calls-to-vhost_scsi_set_endpoint.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-213026-greg=kroah.com@vger.kernel.org Mon Feb  2 07:47:41 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Feb 2026 14:47:19 +0800
Subject: vhost-scsi: Fix handling of multiple calls to vhost_scsi_set_endpoint
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, michael.christie@oracle.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, mlombard@redhat.com, asias@redhat.com, nab@linux-iscsi.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, netdev@vger.kernel.org, wh1sper@zju.edu.cn, sgarzare@redhat.com
Message-ID: <20260202064719.642351-1-1468888505@139.com>

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 5dd639a1646ef5fe8f4bf270fad47c5c3755b9b6 ]

If vhost_scsi_set_endpoint is called multiple times without a
vhost_scsi_clear_endpoint between them, we can hit multiple bugs
found by Haoran Zhang:

1. Use-after-free when no tpgs are found:

This fixes a use after free that occurs when vhost_scsi_set_endpoint is
called more than once and calls after the first call do not find any
tpgs to add to the vs_tpg. When vhost_scsi_set_endpoint first finds
tpgs to add to the vs_tpg array match=true, so we will do:

vhost_vq_set_backend(vq, vs_tpg);
...

kfree(vs->vs_tpg);
vs->vs_tpg = vs_tpg;

If vhost_scsi_set_endpoint is called again and no tpgs are found
match=false so we skip the vhost_vq_set_backend call leaving the
pointer to the vs_tpg we then free via:

kfree(vs->vs_tpg);
vs->vs_tpg = vs_tpg;

If a scsi request is then sent we do:

vhost_scsi_handle_vq -> vhost_scsi_get_req -> vhost_vq_get_backend

which sees the vs_tpg we just did a kfree on.

2. Tpg dir removal hang:

This patch fixes an issue where we cannot remove a LIO/target layer
tpg (and structs above it like the target) dir due to the refcount
dropping to -1.

The problem is that if vhost_scsi_set_endpoint detects a tpg is already
in the vs->vs_tpg array or if the tpg has been removed so
target_depend_item fails, the undepend goto handler will do
target_undepend_item on all tpgs in the vs_tpg array dropping their
refcount to 0. At this time vs_tpg contains both the tpgs we have added
in the current vhost_scsi_set_endpoint call as well as tpgs we added in
previous calls which are also in vs->vs_tpg.

Later, when vhost_scsi_clear_endpoint runs it will do
target_undepend_item on all the tpgs in the vs->vs_tpg which will drop
their refcount to -1. Userspace will then not be able to remove the tpg
and will hang when it tries to do rmdir on the tpg dir.

3. Tpg leak:

This fixes a bug where we can leak tpgs and cause them to be
un-removable because the target name is overwritten when
vhost_scsi_set_endpoint is called multiple times but with different
target names.

The bug occurs if a user has called VHOST_SCSI_SET_ENDPOINT and setup
a vhost-scsi device to target/tpg mapping, then calls
VHOST_SCSI_SET_ENDPOINT again with a new target name that has tpgs we
haven't seen before (target1 has tpg1 but target2 has tpg2). When this
happens we don't teardown the old target tpg mapping and just overwrite
the target name and the vs->vs_tpg array. Later when we do
vhost_scsi_clear_endpoint, we are passed in either target1 or target2's
name and we will only match that target's tpgs when we loop over the
vs->vs_tpg. We will then return from the function without doing
target_undepend_item on the tpgs.

Because of all these bugs, it looks like being able to call
vhost_scsi_set_endpoint multiple times was never supported. The major
user, QEMU, already has checks to prevent this use case. So to fix the
issues, this patch prevents vhost_scsi_set_endpoint from being called
if it's already successfully added tpgs. To add, remove or change the
tpg config or target name, you must do a vhost_scsi_clear_endpoint
first.

Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
Fixes: 4f7f46d32c98 ("tcm_vhost: Use vq->private_data to indicate if the endpoint is setup")
Reported-by: Haoran Zhang <wh1sper@zju.edu.cn>
Closes: https://lore.kernel.org/virtualization/e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com/T/#me6c0041ce376677419b9b2563494172a01487ecb
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20250129210922.121533-1-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/scsi.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1572,14 +1572,19 @@ vhost_scsi_set_endpoint(struct vhost_scs
 		}
 	}
 
+	if (vs->vs_tpg) {
+		pr_err("vhost-scsi endpoint already set for %s.\n",
+		       vs->vs_vhost_wwpn);
+		ret = -EEXIST;
+		goto out;
+	}
+
 	len = sizeof(vs_tpg[0]) * VHOST_SCSI_MAX_TARGET;
 	vs_tpg = kzalloc(len, GFP_KERNEL);
 	if (!vs_tpg) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (vs->vs_tpg)
-		memcpy(vs_tpg, vs->vs_tpg, len);
 
 	list_for_each_entry(tpg, &vhost_scsi_list, tv_tpg_list) {
 		mutex_lock(&tpg->tv_tpg_mutex);
@@ -1594,11 +1599,6 @@ vhost_scsi_set_endpoint(struct vhost_scs
 		tv_tport = tpg->tport;
 
 		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
-			if (vs->vs_tpg && vs->vs_tpg[tpg->tport_tpgt]) {
-				mutex_unlock(&tpg->tv_tpg_mutex);
-				ret = -EEXIST;
-				goto undepend;
-			}
 			/*
 			 * In order to ensure individual vhost-scsi configfs
 			 * groups cannot be removed while in use by vhost ioctl,
@@ -1643,15 +1643,15 @@ vhost_scsi_set_endpoint(struct vhost_scs
 		}
 		ret = 0;
 	} else {
-		ret = -EEXIST;
+		ret = -ENODEV;
+		goto free_tpg;
 	}
 
 	/*
-	 * Act as synchronize_rcu to make sure access to
-	 * old vs->vs_tpg is finished.
+	 * Act as synchronize_rcu to make sure requests after this point
+	 * see a fully setup device.
 	 */
 	vhost_scsi_flush(vs);
-	kfree(vs->vs_tpg);
 	vs->vs_tpg = vs_tpg;
 	goto out;
 
@@ -1668,6 +1668,7 @@ undepend:
 			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
 		}
 	}
+free_tpg:
 	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
@@ -1757,6 +1758,7 @@ vhost_scsi_clear_endpoint(struct vhost_s
 	vhost_scsi_flush(vs);
 	kfree(vs->vs_tpg);
 	vs->vs_tpg = NULL;
+	memset(vs->vs_vhost_wwpn, 0, sizeof(vs->vs_vhost_wwpn));
 	WARN_ON(vs->vs_events_nr);
 	mutex_unlock(&vs->dev.mutex);
 	mutex_unlock(&vhost_scsi_mutex);


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/vhost-scsi-fix-handling-of-multiple-calls-to-vhost_scsi_set_endpoint.patch
queue-6.1/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.1/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.1/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.1/ksmbd-fix-use-after-free-in-ksmbd_session_rpc_open.patch
queue-6.1/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
queue-6.1/sctp-linearize-cloned-gso-packets-in-sctp_rcv.patch
