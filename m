Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD9385D69
	for <patches@lists.linux.dev>; Wed, 24 Jun 2026 08:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782288269; cv=none; b=AqQR23kP3T2uCoCjgpiPjg0qsBuYfAOo0ip5BJywJ2LTpk/kDEPvLDCpljMEqt84wPcxXIbmdTHiV1r3zTGmR277kJFtZhDQpx7voy8KROalCWzPqGuTkc+R3zmtzJF0xQhxFrN3smO+z6GdK80Xppej5pWhVJIDYIX9jViut5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782288269; c=relaxed/simple;
	bh=z0alSbmaJJWcA52g7/M1v2TN0Rv1w27NXV05Q0CgH8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ChvQLcsJUNBJrPBNMxr6AzW8E+PslR0cn1DTAnEcOPAqYMs6zjaeQgFchcKP7lqZM8ppGwnxCOFxjnbWV3bPb4TlN69mDxkQ86dDog2hnXKq4g35smze8dEzdSTXN7GU8GyQNgUHiUNqnGT2rcVBWXbgN29bPzyac24hNGYihAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=TRWWoEw/; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="TRWWoEw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782288196;
	bh=oyTCBFYG5IAdfwE4ZxaVrnJ4/VM+a5SBJWOHsTLTxtA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=TRWWoEw/eb0FmpcfYl3X06ZHkwn3TSNfRkZp4sUCE8nsqKao284l0bGGqcJ7TcA/s
	 t+6s/2Ado11/HIdzZvCqkUc5wTlO35bhSK8I5C6gtCE0PcXTOaSsrMHWGlj848k7Nm
	 tYxq6563dXigNMjuAcT3j/lkkBg7GRaCEmQjoI2s=
X-QQ-mid: esmtpgz12t1782288193teabd5a58
X-QQ-Originating-IP: WaZyHcVvJRB1n7n/2DKbQ74NJKPnAMc/EFQ3L+s14+s=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 24 Jun 2026 16:03:11 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11382400478677146413
From: Wentao Guan <guanwentao@uniontech.com>
To: iklatzco@gmail.com,
	gregkh@linuxfoundation.org
Cc: 00107082@163.com,
	patches@lists.linux.dev,
	peterz@infradead.org,
	sashal@kernel.org,
	stable@vger.kernel.org,
	yeoreum.yun@arm.com
Subject: Re: perf: Fix dangling cgroup pointer in cpuctx
Date: Wed, 24 Jun 2026 16:03:10 +0800
Message-Id: <20260624080310.2502480-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260616145120.525872058@linuxfoundation.org>
References: <20260616145120.525872058@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: M47yMtM9UvTazSrR+mRSIzgjWUhnL+YgGndaRoS68Dy8dMVr1aOOjlhs
	HmBDaCm6SoBc2baYOj5YwueNbpuVxZCeP9NfiQfIsHho/yUhEaAKz0txUYKutEiiW876u+D
	9JHsNnOzsOkDG/yyt91Awig7pdYibu0hcQ9jGtL2USCvJRcfHcJuUxoxR5sOALNDc+6+fMs
	qjhVbO4MDZJ10eR4x28vSrCuwJ+kvm1YlzkK5IHdyAtwgjU30FrkW7OjCFDMusTnBLNGMRB
	LQhrl/7uJYTNittHW6xiieOueLFq6DgU8CbT0rWP4CjzdCn7w5E1LXVcIx5HHzpofw1nKbs
	CVhb5NcLaKayGmn89uy8VgKqV5p0T0807pbJWWn3NJDpIaUaPX/xrtpqKHzRT+4nxeEA2PK
	mTWSzO9vFBY2eGc4mzJZyYVXklaBhaydixTDX5NLYyyFet4id3x+a2SVeG6U8nRU0uQqoEO
	RX1fT2AIfDMwGlaDFwVAa0Py4OuvZDLu5IZRwW9FILy1f/zrys3ELiWUG22m0EPquH5kFIY
	4phDKWqgII5b8vAaPsuQ/wi+Cn2PVUckETYOtVNizHgkhdELrKHkCknD9xPTeEwG93Bf9Gx
	CGkn9lK0RJh9ELRgKBwgxtejM9EK5qg9CTgpzHNy1Ubvd2Nu5epfFsX6LQp3+N3GXyJuydy
	xb5LWUfadUER2pt1mvWvJBObykglMBBZ8U2KFhYjLYQ8vc1/LY/cU69Rbg96O/eLohdlezV
	Ka65A/YOCOZ2YC5iASvYE5U7BH9nrWhXGWsRlBeKJCPDy0cEqUX9zT3tVeNgDE4nS1rzzne
	+dhmV+JnIFg7rZsMBulFvxlBJglSTEUEuFo7RRUTQxilbs4BaobZLoUypJQS98DYhF1w4wn
	y9cG5AhrmsXaj6cUsbQx5AfjZ+KD0ctESfLtVI66rDG09NMGihrfadQ5jLRThQxtwbUpHBJ
	RyLB5K8wmuf14+OOLJeL6W9AFZ5ucSvA0MzIo6QSttL3rPZFbALj3XsrbjH+U1JdaZLUxxT
	wWKzJFs9PKoSrhAQCp
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Hello, 

I noticed your backport missed - 'event->pending_disable = 1;',
which different than upstream version, is that true?

BRs
Wentao Guan
