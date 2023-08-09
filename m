Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B0C1774C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475FBC433C8;
	Wed,  9 Aug 2023 11:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579497;
	bh=Omgf3TMvIvcCXys6p4t3IpxwrIM4ZEU5yexsvosOhio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLPYkO55SOGXOwY6N0CBhXper5DLAZhInLjyogrq9ScfcawjVSNxe5W/D/q1CcAfC
	 o8453ReUzs+/zz3KzZyTyZ2mdX2Cj1qdfipHDNj+YuL3Un0O5W6Pz4Qn4vIwBLdnav
	 XiUZafQH1l7BeoQRX7Hkm4K8bCBwHEVUyqvhSkN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Ilia Mirkin <imirkin@alum.mit.edu>
Subject: [PATCH 4.19 005/323] drm/edid: Fix uninitialized variable in drm_cvt_modes()
Date: Wed,  9 Aug 2023 12:37:23 +0200
Message-ID: <20230809103658.358120071@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lyude Paul <lyude@redhat.com>

commit 991fcb77f490390bcad89fa67d95763c58cdc04c upstream.

Noticed this when trying to compile with -Wall on a kernel fork. We
potentially don't set width here, which causes the compiler to complain
about width potentially being uninitialized in drm_cvt_modes(). So, let's
fix that.

Changes since v1:
* Don't emit an error as this code isn't reachable, just mark it as such
Changes since v2:
* Remove now unused variable

Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ilia Mirkin <imirkin@alum.mit.edu>
Link: https://patchwork.freedesktop.org/patch/msgid/20201105235703.1328115-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2798,6 +2798,8 @@ static int drm_cvt_modes(struct drm_conn
 		case 0x0c:
 			width = height * 15 / 9;
 			break;
+		default:
+			unreachable();
 		}
 
 		for (j = 1; j < 5; j++) {


