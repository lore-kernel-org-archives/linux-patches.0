Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831877;
	b=aySZ2CbyPoof3vXVtBQ9b46XU3fPzS1vmshzVYrv6KrJWLA5AppZDW3jQGye6Jl0beEI
	 1DURbwdy9iaPuDDem+Ur7TTG29rHPaqBkR6rPiKgQoXKelJ2MJBEM2Jtolr9C73DI5/7l
	 g/ENDjsWHL6qQy09yD2d2T5RaSQI6bqLQwNg3bygcqQEge3/aLjvgBTln1PNEiFUqMHFD
	 JdGFTuWA5aR0q4DvohRTeuUxdTs60wyyWunY2jeeHHqL7gp+lOl1w0ZJNs6oqiHAGJ1U2
	 CHZZ3TejGLLYoQI6JChrxR/QKb6a2sLr9YPAZp4hawAvpS6W7dfkkFS5MjfkqcCuc/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQGip1c/D2h8+u/Y4246PT7d8TtEroxGLVDsD1ROpTA=;
	b=Z6Rlr7XdYYlY8LvE4ttj30bpf5gPABG0DDcloYkL0fkq8jBYX+Cz2ocBZnTnCy0yjtZf
	 RhrlXCCps9cSAHTViF/Zye0Bc75ZuzFy/n8S1c3uWjwm4mDtiMp5QjbizeioNCIcCtHk9
	 g0sbhb00+3l5uN3Y8kae//bDaOFEKnaSl6XZCaljUELVovgaGJiXEa+NC7+Uv2Mi88yKc
	 wwJealBtpLhRrHVhARhbaO5puzExwwdAkbEYNQ/mO0plAmxr+kiEMA9qniH5M7RlVXB/g
	 CRN+ERV/FE+egFngwxOOV71q7ZpnXYl/3qOyV5M3KQ05MGElqLSUXlCoz20e8WUwqkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSgAq0i8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED71606A326;
	Wed,  4 Nov 2026 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fSgAq0i8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE1C1F000C1;
	Wed,  4 Nov 2026 22:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831877;
	bh=QQGip1c/D2h8+u/Y4246PT7d8TtEroxGLVDsD1ROpTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSgAq0i8phrpYLNWMo3mp0FF9JW4UuhYWxKOFt+TUrpwTrg4OhfK6cVddFS1W/4T+
	 MZ7gjPGLudiPxEryYg8co7FuNfNKqMrK/+i9HcCrKkcVkcljbdrHXvrPvdTme9+vZB
	 df6pnJvzOv1/NQbqvcJQ8568cxm8VucddA6HIKrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.ibm.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0969/1005] ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN
Date: Wed,  4 Nov 2026 16:11:42 -0500
Message-ID: <20261104211110.211464981@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 333ad304d4794d6384087ea7fc16e58ab642809b upstream.

When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
"override_creds"), overlayfs saves those restricted credentials in
ofs->creator_cred. ovl_fill_super() then wraps the entire mount setup in
with_ovl_creds(), switching to those restricted credentials for the
duration.

Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
against current credentials. With restricted credentials active, this
check fails with -EPERM even though the task issuing
FSCONFIG_CMD_CREATE is fully privileged.

Use the mounter's real credentials only for cloning the private layer
mounts. Keep all other backing filesystem operations during mount setup
under the stashed credentials.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
Closes: https://lore.kernel.org/linux-unionfs/20260924112858.51392-1-disgoel@linux.ibm.com
Fixes: c28f922c9dcee ("clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: 6.18 has no scoped_with_creds(), use scoped_class(override_creds)]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -498,6 +498,20 @@ static int ovl_report_in_use(struct ovl_
 	}
 }
 
+/*
+ * clone_private_mount() checks CAP_SYS_ADMIN in current->cred.
+ * ovl_fill_super() runs under the stashed creator cred, which
+ * override_creds may have dropped.
+ * The task that issued FSCONFIG_CMD_CREATE is still current->real_cred, so
+ * use that only for the clone. creator_cred stays in effect for every other
+ * backing-fs operation.
+ */
+static struct vfsmount *ovl_clone_private_mount(const struct path *path)
+{
+	scoped_class(override_creds, cred, current_real_cred())
+		return clone_private_mount(path);
+}
+
 static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 			 struct ovl_layer *upper_layer,
 			 const struct path *upperpath)
@@ -521,7 +535,7 @@ static int ovl_get_upper(struct super_bl
 	if (err)
 		goto out;
 
-	upper_mnt = clone_private_mount(upperpath);
+	upper_mnt = ovl_clone_private_mount(upperpath);
 	err = PTR_ERR(upper_mnt);
 	if (IS_ERR(upper_mnt)) {
 		pr_err("failed to clone upperpath\n");
@@ -1102,7 +1116,7 @@ static int ovl_get_layers(struct super_b
 			}
 		}
 
-		mnt = clone_private_mount(&l->path);
+		mnt = ovl_clone_private_mount(&l->path);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("failed to clone lowerpath\n");


