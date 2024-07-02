Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06ED15218A;
	Tue,  2 Jul 2024 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940324; cv=none; b=fiF9naQge5x3vrK29rSe9kDWyJ2ghyMEd1ny5Qs6wPfNYBahVn1HvFn5OlR4MlUpoWXjB0J/vud0VuPH6z5LY7cEefN564mYgcKRiBrkGbzZU+wpjEDjl42FImnWKaKya5BQEjWOxvafxv4++fKfws4nuBNIlL6XXbjx6SfW7zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940324; c=relaxed/simple;
	bh=l6RbndkR2CFvO/vR2LDxdGzw9jnXmVkTRVQ6PKOpR18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7gUgQN7U8Nl/+/f7gb/idQWrPVyr+NP9CNyVNpM4eUMcQzoSwH3yyiChJ3+8HRqBBPKdGrvuY6TncBnRB2S7hHWFrn9dRwW+BVtyV4I4JZHo+oTsurYVDAXWmLiVzFtpz0cB8ndODd5ajPNjU+otLPTbxlBCWUTOsS73z5zd6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNPBlWAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNPBlWAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6213EC116B1;
	Tue,  2 Jul 2024 17:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940323;
	bh=l6RbndkR2CFvO/vR2LDxdGzw9jnXmVkTRVQ6PKOpR18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNPBlWAgTPz74pxXGL2CVpaQIkiohmVUyCoXp6FAI+ywy7UZ1J7+kBlzN8OwXafyX
	 9jQngVTD/i8fNwJ2D9od8L+44aPt3z8TDu12EjcmjmhGnksA3VSLUDfNtd/1k9N14K
	 lqjh9JWY6aPa9ZLcxAkGu18fiCM3+Hp0grVif4nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 079/222] drm/xe/xe_devcoredump: Check NULL before assignments
Date: Tue,  2 Jul 2024 19:01:57 +0200
Message-ID: <20240702170246.999703496@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit b15e65349553b1689d15fbdebea874ca5ae2274a ]

Assign 'xe_devcoredump_snapshot *' and 'xe_device *' only if
'coredump' is not NULL.

v2
- Fix commit messages.

v3
- Define variables before code.(Ashutosh/Jose)

v4
- Drop return check for coredump_to_xe. (Jose/Rodrigo)

v5
- Modify misleading commit message. (Matt)

Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240328123739.3633428-1-himal.prasad.ghimiray@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_devcoredump.c b/drivers/gpu/drm/xe/xe_devcoredump.c
index 68d3d623a05bf..ccec291b02ccd 100644
--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -74,17 +74,19 @@ static ssize_t xe_devcoredump_read(char *buffer, loff_t offset,
 				   size_t count, void *data, size_t datalen)
 {
 	struct xe_devcoredump *coredump = data;
-	struct xe_device *xe = coredump_to_xe(coredump);
-	struct xe_devcoredump_snapshot *ss = &coredump->snapshot;
+	struct xe_device *xe;
+	struct xe_devcoredump_snapshot *ss;
 	struct drm_printer p;
 	struct drm_print_iterator iter;
 	struct timespec64 ts;
 	int i;
 
-	/* Our device is gone already... */
-	if (!data || !coredump_to_xe(coredump))
+	if (!coredump)
 		return -ENODEV;
 
+	xe = coredump_to_xe(coredump);
+	ss = &coredump->snapshot;
+
 	/* Ensure delayed work is captured before continuing */
 	flush_work(&ss->work);
 
-- 
2.43.0



