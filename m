Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629193D170E;
	Fri, 15 May 2026 16:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862666; cv=none; b=SG2wfXwpb5KkpXANiUz4PtBzmBJiPSv/7aqVoQ5Go6a4jSHPwPgU9STdWGLRFt42YmKNFP/GvjyWywtZeDLDUPKNDPmbOy+yPgqDUs+taBULxmtB7HDJv8bipvHu2/lJpI6jW257QpWmnR6SVrUohWxw5VVXrcdPHuDQ+jjJGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862666; c=relaxed/simple;
	bh=Fc7l09PqZHuF73VC9+2emNTCltmjcE6XF8/oGsXCJBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=goI5SNA/BwlGOPAmQ6ILYSmpcx5hb8j/OI3ummg+0lmNh1MuAWpnTnQSzpw+i0wKMPQTZ4DvOagDQszpE7QzCbvrvpR0qHpWoEaL/EtKnTMkxcr8Q94Kev+Qe5RbJ+FCTg//QYIEaTMQTdLeWJuBzKX6XtU2rjhGd9NZSYIMo7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmSdiagZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmSdiagZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA79C2BCC7;
	Fri, 15 May 2026 16:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862666;
	bh=Fc7l09PqZHuF73VC9+2emNTCltmjcE6XF8/oGsXCJBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmSdiagZptIQA+fvCXHBzUqSD9p0rhmbYK7bGWLq+ic3YrhltQivkccf2Rkb4c392
	 0ZVDGbN8nhc1VqeX7GRgdnIhO35wKEfxQsZLjsOklYUXR91TSRC7RjkG5fzf0NH+dX
	 pr5CEs+W40ROzdwJRAiMP3lMaKN3TmtWtSBhdkBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Nemesa Garg <nemesa.garg@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 7.0 129/201] drm/i915/psr: Init variable to avoid early exit from et alignment loop
Date: Fri, 15 May 2026 17:49:07 +0200
Message-ID: <20260515154701.359607448@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit 314f6179e370988ac00dadf373a4f6166eb3db15 upstream.

Uninitialized boolean variable may cause unwanted exit from et alignment
loop. Fix this by initializing it as false.

Fixes: 1be2fca84f52 ("drm/i915/psr: Repeat Selective Update area alignment")
Cc: <stable@vger.kernel.org> # v6.9+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Nemesa Garg <nemesa.garg@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260413112345.88853-1-jouni.hogander@intel.com
(cherry picked from commit 289678a90b8cf81e3514c9d6c667235cd39c7acf)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2970,7 +2970,7 @@ int intel_psr2_sel_fetch_update(struct i
 		return ret;
 
 	do {
-		bool cursor_in_su_area;
+		bool cursor_in_su_area = false;
 
 		/*
 		 * Adjust su area to cover cursor fully as necessary


