Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271A4259CBD;
	Tue, 17 Feb 2026 20:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361320; cv=none; b=XB3uEoIWTegiarneZBJc2LEYAY67biEeIdzKhKtZaTB9w4MJp0gijmD1YQD2040MzqjM/JDjRjTuf6aX6/poYBOfbAlJ2x9ps7vjTbEYdxlflzcl8jTBaKly2TNir9qeRMlg5UVpFX4ybBjCDgspLKoCtjQ/LAdiZnIk06P/WLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361320; c=relaxed/simple;
	bh=q/0Bbkg2Gx7R8KN0Aej5tLDgKq2VALFREV9+A2WMVA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aq0ajpAo7fFaFBh/rjplweiZ4X//7yiOGzRZhe5TYj+R6XNisnKTmfsG387X/BVSSeiUW9PGyFWL4C8weZo2psWyWVyMiQV4+eAZfU+7XcMpFLuf9zXFPJEoX3BaWFcZPSUy9YYQLmcfDeNapLfg7lRz9fHRB3VBVDYpso557lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef9Yy+Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef9Yy+Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B89C4CEF7;
	Tue, 17 Feb 2026 20:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361320;
	bh=q/0Bbkg2Gx7R8KN0Aej5tLDgKq2VALFREV9+A2WMVA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ef9Yy+Cycc06kJch84VH7JSiMt8kqCUvp67rJNdR7v9YJ4bzbpx7Kp0a6BW7wZIkT
	 FqgSbgYptdRs6JOEdlL4OFcevmWjOQL17rx8QpxJfOK7IiKnPuBNmcvs8pDb1k4yPZ
	 qfZPTQPhNIE6Y6lkVp9LpRyxveuJDfOnKdw0JMmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <listout@listout.xyz>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=206=2E1=2034/64=5D=20=3D=3FUTF-8=3Fq=3Fdrm/tegra=3A=3D20hdmi=3A=3D20sor=3A=3D20Fix=3D20error=3A=3D20variable=3D20=3F=3D=20=3D=3FUTF-8=3Fq=3F=3DE2=3D80=3D98j=3DE2=3D80=3D99=3D20set=3D20but=3D20not=3D20used=3F=3D?=
Date: Tue, 17 Feb 2026 21:31:30 +0100
Message-ID: <20260217200008.791628703@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit 1beee8d0c263b3e239c8d6616e4f8bb700bed658 ]

The variable j is set, however never used in or outside the loop, thus
resulting in dead code.
Building with GCC 16 results in a build error due to
-Werror=unused-but-set-variable= enabled by default.
This patch clean up the dead code and fixes the build error.

Example build log:
drivers/gpu/drm/tegra/sor.c:1867:19: error: variable ‘j’ set but not used [-Werror=unused-but-set-variable=]
 1867 |         size_t i, j;
      |                   ^

Signed-off-by: Brahmajit Das <listout@listout.xyz>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250901212020.3757519-1-listout@listout.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/hdmi.c | 4 ++--
 drivers/gpu/drm/tegra/sor.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index c66764c0bd250..47f794a367ba1 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -654,7 +654,7 @@ static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi, const void *data,
 {
 	const u8 *ptr = data;
 	unsigned long offset;
-	size_t i, j;
+	size_t i;
 	u32 value;
 
 	switch (ptr[0]) {
@@ -687,7 +687,7 @@ static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi, const void *data,
 	 * - subpack_low: bytes 0 - 3
 	 * - subpack_high: bytes 4 - 6 (with byte 7 padded to 0x00)
 	 */
-	for (i = 3, j = 0; i < size; i += 7, j += 8) {
+	for (i = 3; i < size; i += 7) {
 		size_t rem = size - i, num = min_t(size_t, rem, 4);
 
 		value = tegra_hdmi_subpack(&ptr[i], num);
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 77723d5f1d3fd..ce8e299b6afb6 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -1860,7 +1860,7 @@ static void tegra_sor_hdmi_write_infopack(struct tegra_sor *sor,
 {
 	const u8 *ptr = data;
 	unsigned long offset;
-	size_t i, j;
+	size_t i;
 	u32 value;
 
 	switch (ptr[0]) {
@@ -1893,7 +1893,7 @@ static void tegra_sor_hdmi_write_infopack(struct tegra_sor *sor,
 	 * - subpack_low: bytes 0 - 3
 	 * - subpack_high: bytes 4 - 6 (with byte 7 padded to 0x00)
 	 */
-	for (i = 3, j = 0; i < size; i += 7, j += 8) {
+	for (i = 3; i < size; i += 7) {
 		size_t rem = size - i, num = min_t(size_t, rem, 4);
 
 		value = tegra_sor_hdmi_subpack(&ptr[i], num);
-- 
2.51.0



