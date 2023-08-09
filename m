Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99416171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D3CC433C9;
	Wed,  9 Aug 2023 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578927;
	bh=+PNxod4OvDHmAkHY8n88tQJmYujZXunDAdYKP+UXrXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5nWEb+9otlyVlb87wNmhKzt0Uz4p6+BCer8BcZHTd4WT4/6EhwikbOfOU7ttbq3P
	 idYd4Obtg8hQMQWVO2GmFShYe5r8lGUJlPHgYx5tJhsg5T3Naec7Wew7oJQ8iIll2K
	 ugYYZNouZKfY6l4LTg6XySTSv1BaH+8WkOK8Nnac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Ilia Mirkin <imirkin@alum.mit.edu>
Subject: [PATCH 4.14 005/204] drm/edid: Fix uninitialized variable in drm_cvt_modes()
Date: Wed,  9 Aug 2023 12:39:03 +0200
Message-ID: <20230809103642.739475096@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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
@@ -2691,6 +2691,8 @@ static int drm_cvt_modes(struct drm_conn
 		case 0x0c:
 			width = height * 15 / 9;
 			break;
+		default:
+			unreachable();
 		}
 
 		for (j = 1; j < 5; j++) {


